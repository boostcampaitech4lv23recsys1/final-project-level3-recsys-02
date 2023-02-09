import argparse
import os
import pickle
import random
import time
from datetime import datetime

import numpy as np
import torch
from torch.utils.data import DataLoader, RandomSampler, SequentialSampler

import label2string
from datasets import SASRecDataset
from models import S3RecModel
from predictor import Predictor
from trainers import FinetuneTrainer
from utils import (EarlyStopping, check_path, get_item2attribute_json,
                   get_user_seqs, set_seed)
import psycopg2
import pandas as pd

def main():
    parser = argparse.ArgumentParser()

    parser.add_argument("--data_dir", default="./data/", type=str)
    parser.add_argument("--data_dir2", default="kdy_kdy1000", type=str)
    parser.add_argument("--output_dir", default="output/", type=str)
    parser.add_argument("--data_name", default="kdy_kdy1000", type=str)
    parser.add_argument("--do_eval", action="store_true")
    parser.add_argument(
        "--ckp", default=10, type=int, help="pretrain epochs 10, 20, 30..."
    )

    #  args
    parser.add_argument("--model_name", default="Finetune_full", type=str)
    parser.add_argument(
        "--hidden_size", type=int, default=64, help="hidden size of transformer model"
    )
    parser.add_argument(
        "--num_hidden_layers", type=int, default=2, help="number of layers"
    )
    parser.add_argument("--num_attention_heads", default=2, type=int)
    parser.add_argument("--hidden_act", default="gelu", type=str)  # gelu relu
    parser.add_argument(
        "--attention_probs_dropout_prob",
        type=float,
        default=0.5,
        help="attention dropout p",
    )
    parser.add_argument(
        "--hidden_dropout_prob", type=float, default=0.5, help="hidden dropout p"
    )
    parser.add_argument("--initializer_range", type=float, default=0.02)
    parser.add_argument("--max_seq_length", default=50, type=int)

    # train args
    parser.add_argument("--lr", type=float, default=0.001, help="learning rate of adam")
    parser.add_argument(
        "--batch_size", type=int, default=256, help="number of batch_size"
    )
    parser.add_argument("--epochs", type=int, default=200, help="number of epochs")
    parser.add_argument("--no_cuda", action="store_true")
    parser.add_argument("--log_freq", type=int, default=1, help="per epoch print res")
    parser.add_argument("--seed", default=42, type=int)

    parser.add_argument(
        "--weight_decay", type=float, default=0.0, help="weight_decay of adam"
    )
    parser.add_argument(
        "--adam_beta1", type=float, default=0.9, help="adam first beta value"
    )
    parser.add_argument(
        "--adam_beta2", type=float, default=0.999, help="adam second beta value"
    )
    parser.add_argument("--gpu_id", type=str, default="0", help="gpu_id")

    args = parser.parse_args()

    set_seed(args.seed)
    check_path(args.output_dir)

    os.environ["CUDA_VISIBLE_DEVICES"] = args.gpu_id
    args.cuda_condition = torch.cuda.is_available() and not args.no_cuda
    
    db_connect = psycopg2.connect(
        user="myuser",
        password="mypassword",
        host="34.64.50.61",
        port=5432,
        database="mydatabase",
    )
    
    args.data_file = pd.read_sql("select * from inter limit 50;", db_connect)
    
    # args.data_file = (
    #     args.data_dir + args.data_name + "/artifacts/interaction.txt"
    # )  # interaction data file -> user, interaction만 있어야 함
    item2attribute_file = (
        args.data_dir + args.data_name + "/artifacts/_item2attributes.json"
    )  # attribute data file

    user_seq, max_item, valid_rating_matrix, test_rating_matrix = get_user_seqs(
        args.data_file
    )

    args_str = f"{args.model_name}-{args.data_name}-{args.ckp}"
    checkpoint = args_str + ".pt"
    # inference output 저장용
    # args.checkpoint_path = os.path.join(args.output_dir+args.data_name+"/inference/", checkpoint)
    # if not os.path.exists(args.checkpoint_path) :
    #     os.mkdir(args.checkpoint_path)
    # args.log_file = os.path.join(args.output_dir+args.data_name+"/inference/", args_str + '.txt')
    #print(args)
    # with open(args.log_file, 'a') as f:
    #     f.write(str(args) + '\n')
    
    item2attribute, attribute_size = get_item2attribute_json(item2attribute_file)
    args.train_matrix = valid_rating_matrix

    args.item_size = max_item + 2
    args.mask_id = max_item + 1
    args.attribute_size = attribute_size + 1
    args.item2attribute = item2attribute

    infer_dataset = SASRecDataset(args, user_seq, data_type="infer")
    # infer_sampler = SequentialSampler(infer_dataset)
    # infer_dataloader = DataLoader(infer_dataset, sampler=infer_sampler, batch_size=args.batch_size)
    infer_dataloader = DataLoader(infer_dataset, batch_size=args.batch_size)

    model = S3RecModel(args=args)

    predictor = Predictor(model, infer_dataloader, args)

    # trainer.load(args.checkpoint_path)
    #predictor.load(os.path.join(args.output_dir, checkpoint))
    print(f"Load model from {os.path.join(args.output_dir,checkpoint)} for inference!")

    ######################### inference ##################################################
    # predict top k(20) tracks
    #start = time.time()
    #for i in range(1000):
    pred_list = predictor.get_topk_main(0, full_sort=True)
    #print("model latency :", (time.time() - start)/1000)
    print(np.shape(np.array(pred_list)))
    
    return

    # predict top k(20) tag-tracks
    tags = ["pop", "jazz"]
    attributes_dict = pickle.load(
        open(
            args.data_dir + args.data_name + "/artifacts/attributes_dict_list.pkl", "rb"
        )
    )
    labeled_tags = list(map(lambda x: attributes_dict[-1][x], tags))
    pred_list_tag = []
    for tag in labeled_tags:
        pred_list_tag.append(predictor.get_topk_tag(0, tag, full_sort=True))

    # predict top k(20) artist-tracks
    artists = ["(G)I-DLE", "$uicideboy$"]
    attributes_dict = pickle.load(
        open(
            args.data_dir + args.data_name + "/artifacts/attributes_dict_list.pkl", "rb"
        )
    )
    labeled_tags = list(map(lambda x: attributes_dict[-2][x], artists))
    pred_list_artist = []
    for tag in labeled_tags:
        pred_list_artist.append(predictor.get_topk_artist(0, tag, full_sort=True))

    # predict top k(20) users
    target_user = "mbk"  # for test
    # user to label
    target_user_label = 100  # for test
    pred_list_users = predictor.get_topk_users(target_user_label, pred_list)

    ################################################## save ##################################################
    # save prediction results to "pred_list" folder
    now = datetime.now()
    month = now.strftime("%m")
    day = now.strftime("%d")
    hour = now.strftime("%H")

    #### save pred_list(main) ###
    if not os.path.exists(
        os.path.join(args.output_dir + args.data_name + "/pred_list/", "main/")
    ):
        os.mkdir(
            os.path.join(args.output_dir + args.data_name + "/pred_list/", "main/")
        )
    with open(
        os.path.join(
            args.output_dir + args.data_name + "/pred_list/main/",
            f"LastFM_pred_label-{month}.{day}.{hour}.npy",
        ),
        "wb",
    ) as f:
        np.save(f, pred_list)

    # pred_list_dir = os.path.join(args.output_dir+"inference/", "pred_list/", f"LastFM_pred_list-{month}.{day}.{hour}.npy")
    track_pred_list = label2string.track(pred_list, args)
    user_name_list = label2string.user(pred_list, args)
    # save track_name prediction list
    with open(
        os.path.join(
            args.output_dir + args.data_name + "/pred_list/main/",
            f"LastFM_pred_string-{month}.{day}.{hour}.npy",
        ),
        "wb",
    ) as f:
        np.save(f, track_pred_list)

    #### save pred_list(tag) ###
    # save recommended tracks using tag
    if not os.path.exists(
        os.path.join(args.output_dir + args.data_name + "/pred_list/", "tags/")
    ):
        os.mkdir(
            os.path.join(args.output_dir + args.data_name + "/pred_list/", "tags/")
        )
    for i, tag in enumerate(tags):
        with open(
            os.path.join(
                args.output_dir + args.data_name + "/pred_list/tags/",
                f"LastFM_pred_label_{tag}-{month}.{day}.{hour}.npy",
            ),
            "wb",
        ) as f:
            np.save(f, pred_list_tag[i])
        track_pred_list_tag = label2string.track(pred_list_tag[i], args)
        # user_name_list_tag = label2string.user(pred_list_tag[i], args)
        with open(
            os.path.join(
                args.output_dir + args.data_name + "/pred_list/tags/",
                f"LastFM_pred_string_{tag}-{month}.{day}.{hour}.npy",
            ),
            "wb",
        ) as f:
            np.save(f, track_pred_list_tag)

    #### save pred_list(artist) ###
    if not os.path.exists(
        os.path.join(args.output_dir + args.data_name + "/pred_list/", "artists/")
    ):
        os.mkdir(
            os.path.join(args.output_dir + args.data_name + "/pred_list/", "artists/")
        )
    for i, tag in enumerate(artists):
        with open(
            os.path.join(
                args.output_dir + args.data_name + "/pred_list/artists/",
                f"LastFM_pred_label_{tag}-{month}.{day}.{hour}.npy",
            ),
            "wb",
        ) as f:
            np.save(f, pred_list_tag[i])
        track_pred_list_tag = label2string.track(pred_list_tag[i], args)
        # user_name_list_tag = label2string.user(pred_list_tag[i], args)
        with open(
            os.path.join(
                args.output_dir + args.data_name + "/pred_list/artists/",
                f"LastFM_pred_string_{tag}-{month}.{day}.{hour}.npy",
            ),
            "wb",
        ) as f:
            np.save(f, track_pred_list_tag)

    #### save pred_list(user) ###
    if not os.path.exists(
        os.path.join(args.output_dir + args.data_name + "/pred_list/", "users/")
    ):
        os.mkdir(
            os.path.join(args.output_dir + args.data_name + "/pred_list/", "users/")
        )
    with open(
        os.path.join(
            args.output_dir + args.data_name + "/pred_list/users",
            f"LastFM_pred_label_{target_user}-{month}.{day}.{hour}.npy",
        ),
        "wb",
    ) as f:
        np.save(f, pred_list_users)
    # track_pred_list_tag = label2string.track(pred_list_tag[i], args)
    user_name_list_tag = label2string.user(pred_list_users, args)
    with open(
        os.path.join(
            args.output_dir + args.data_name + "/pred_list/users",
            f"LastFM_pred_string_{target_user}-{month}.{day}.{hour}.npy",
        ),
        "wb",
    ) as f:
        np.save(f, user_name_list_tag)


if __name__ == "__main__":
    main()
