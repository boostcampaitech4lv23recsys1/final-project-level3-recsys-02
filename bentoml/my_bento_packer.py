import argparse
import os
import pandas as pd
import psycopg2
import torch
from models import S3RecModel
from my_bento_service import MyService
from utils import check_path, set_seed
from utils import get_user_seqs
from torch.utils.data import DataLoader
from predictor import Predictor
from datasets import SASRecDataset
import pickle

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
        "--batch_size", type=int, default=16, help="number of batch_size"
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
    args.mode = 'infer'
    os.environ["CUDA_VISIBLE_DEVICES"] = args.gpu_id
    args.item_size = 85685 # 85687 -> 현재(1000) db, 25300 -> 123.pt
    args.attribute_size = 24056

    df = pd.read_sql("select * from inter;", db_connect)
    
    (_, _, args.train_matrix, _,) = get_user_seqs(df)
    
    model = S3RecModel(args=args)
    #print(args.train_matrix)
    user_seq = list(df.sort_values(by = ['date_uts']).groupby(by= ['user_id'])['track_id'].apply(list).reset_index(drop=True))
    infer_dataset = SASRecDataset(args, user_seq, data_type="infer")

    #checkpoint = "/opt/ml/final-bentoml/output/Finetune_full-kdy_kdy1000-10.pt"
    infer_dataloader = DataLoader(infer_dataset, batch_size=args.batch_size)
    
    predictor = Predictor(model, infer_dataloader, args)
    pred_list = predictor.get_topk_main(0, full_sort=True)

    model.load_state_dict(torch.load('model.pt'))
    with open('attributes_dict_list.pkl', 'rb') as f:
        data = pickle.load(f)
    return model, args, pred_list, data


if __name__ == "__main__":
    
    db_connect = psycopg2.connect(
        user="myuser",
        password="mypassword",
        host="34.64.50.61",
        port=5432,
        database="mydatabase",
    )
    
    svc = MyService()
    model, args, pred_list, data = main()
    model = {"S3Rec": model, 'args' : args, 'pred_list': pred_list, 'data':data}
    svc.pack("test_model", model)
    svc.save()
