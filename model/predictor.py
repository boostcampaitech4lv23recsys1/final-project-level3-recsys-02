import numpy as np
import tqdm
import random
import ast

import torch
import torch.nn as nn
from torch.optim import Adam

from trainers import FinetuneTrainer
from utils import recall_at_k, ndcg_k, get_metric

class Predictor:
    def __init__(self, model, infer_dataloader, args):

        self.args = args
        self.cuda_condition = torch.cuda.is_available() and not self.args.no_cuda
        self.device = torch.device("cuda" if self.cuda_condition else "cpu")

        self.model = model
        if self.cuda_condition:
            self.model.cuda()

        # Setting the train and test data loader
        self.infer_dataloader = infer_dataloader

        # self.data_name = self.args.data_name

        print("Total Parameters:", sum([p.nelement() for p in self.model.parameters()]))
        
    def load(self, file_name):
        self.model.load_state_dict(torch.load(file_name))
    
    def get_full_sort_score(self, epoch, answers, pred_list):
        recall, ndcg = [], []
        for k in [5, 10, 15, 20]:
            recall.append(recall_at_k(answers, pred_list, k))
            ndcg.append(ndcg_k(answers, pred_list, k))
        post_fix = {
            "Epoch": epoch,
            "HIT@5": '{:.4f}'.format(recall[0]), "NDCG@5": '{:.4f}'.format(ndcg[0]),
            "HIT@10": '{:.4f}'.format(recall[1]), "NDCG@10": '{:.4f}'.format(ndcg[1]),
            "HIT@20": '{:.4f}'.format(recall[3]), "NDCG@20": '{:.4f}'.format(ndcg[3])
        }
        print(post_fix)
        with open(self.args.log_file, 'a') as f:
            f.write(str(post_fix) + '\n')
        return [recall[0], ndcg[0], recall[1], ndcg[1], recall[3], ndcg[3]], str(post_fix), pred_list
        
    def predict_full(self, seq_out):
        # [item_num hidden_size]
        test_item_emb = self.model.item_embeddings.weight
        # [batch hidden_size ]
        rating_pred = torch.matmul(seq_out, test_item_emb.transpose(0, 1))
        # rating_pred = torch.matmul(seq_out, test_item_emb.transpose(0, 1))
        return rating_pred
    
    def predict_full_attribute(self, seq_out, attribute):
        # [item_num hidden_size]
        attribute_emb = self.model.attribute_embeddings.weight[attribute]
        test_item_emb = self.model.item_embeddings.weight + attribute_emb*2
        # [batch hidden_size ]
        rating_pred = torch.matmul(seq_out, test_item_emb.transpose(0, 1))
        # rating_pred = torch.matmul(seq_out, test_item_emb.transpose(0, 1))
        return rating_pred
    
    
    # interaction data -> matmul with embedding.weight -> sort 20 items by each user
    def get_topk_main(self, k=20, epoch=0, full_sort=True): 
        print("Inferencing 'main' ...")
        return self.iteration(k, epoch, self.infer_dataloader, None, full_sort)
    
    # interaction data -> matmul with embedding.weight+tag_embedding.weight -> sort 20 items by each user
    def get_topk_tag(self, tag, k=20, epoch=0, full_sort=True): 
        print("Inferencing 'tag' ...")
        return self.iteration(k, epoch, self.infer_dataloader, int(tag), full_sort)
    
    # interaction data -> matmul with embedding.weight+tag_embedding.weight -> sort 20 items by each user
    def get_topk_artist(self, artist, k=0, epoch=0, full_sort=True): 
        print("Inferencing 'artist' ...")
        return self.iteration(k, epoch, self.infer_dataloader, int(artist), full_sort)
    
    # target pred_list[20s] @ each pred_list[20s] -> embedding.weight -> matmul -> sort 10 users
    def get_topk_users(self, target_user, pred_list, k):
        self.target_user = target_user # target user index
        self.pred_list = pred_list # item index
        self.item_embeddings = self.model.item_embeddings
        # get item vectors
        pred_tensor = torch.tensor([self.pred_list]).squeeze(0).to(self.device)
        pred_emb = self.item_embeddings(pred_tensor) # n x seq_len x hidden_size(64)
        # sum item vectors
        pred_emb_sum = torch.sum(pred_emb, dim=-2) # n x hidden_size(64)
        # matmul
        target_user_items = self.pred_list[self.target_user]
        target_emb = self.item_embeddings(torch.tensor([target_user_items]).squeeze(0).to(self.device)) # seq_len x hidden_size(64)
        target_emb_sum = torch.sum(target_emb, dim=0)
        user_sims = torch.matmul(target_emb_sum, pred_emb_sum.T).view(1,-1)
        # pick top-k users
        user_sims = user_sims.cpu().data.numpy().copy().squeeze(0) # (962,)
        user_sims[self.target_user] = -10000 # exclude target user
        result_ind = np.argpartition(user_sims, -k)[-k:]
        
        return result_ind
        
            
    def iteration(self, k, epoch, dataloader, attribute=None, full_sort=False):

        # Setting the tqdm progress bar

        rec_data_iter = tqdm.tqdm(enumerate(dataloader),
                                  desc="Recommendation EP:%d" % (epoch),
                                  total=len(dataloader),
                                  bar_format="{l_bar}{r_bar}")
        
        self.model.eval()

        pred_list = None

        if full_sort:
            answer_list = None
            
            if attribute == None : 
                for i, batch in rec_data_iter:
                    # 0. batch_data will be sent into the device(GPU or cpu)
                    batch = tuple(t.to(self.device) for t in batch)
                    # user_ids, input_ids, target_pos, target_neg, answers = batch
                    user_ids, input_ids = batch
                    recommend_output = self.model.finetune(input_ids) # return hidden states
                    recommend_output = recommend_output[:, -1, :] # transformer의 마지막 Sequence값

                    rating_pred = self.predict_full(recommend_output) # item embedding.weight과 matmul

                    rating_pred = rating_pred.cpu().data.numpy().copy()
                    batch_user_index = user_ids.cpu().numpy()
                    rating_pred[self.args.train_matrix[batch_user_index].toarray() > 0] = 0 # train에 사용한 것들 = 0
                    # reference: https://stackoverflow.com/a/23734295, https://stackoverflow.com/a/20104162
                    # argpartition 时间复杂度O(n)  argsort O(nlogn) 只会做
                    # 加负号"-"表示取大的值
                    ind = np.argpartition(rating_pred, -k)[:, -k:] # train에 사용한 것 제외하고 상위 20개 인덱스
                    arr_ind = rating_pred[np.arange(len(rating_pred))[:, None], ind]
                    arr_ind_argsort = np.argsort(arr_ind)[np.arange(len(rating_pred)), ::-1]
                    batch_pred_list = ind[np.arange(len(rating_pred))[:, None], arr_ind_argsort]

                    if i == 0:
                        pred_list = batch_pred_list
                    else:
                        pred_list = np.append(pred_list, batch_pred_list, axis=0)
            else : 
                for i, batch in rec_data_iter:
                    # 0. batch_data will be sent into the device(GPU or cpu)
                    batch = tuple(t.to(self.device) for t in batch)
                    # user_ids, input_ids, target_pos, target_neg, answers = batch
                    user_ids, input_ids = batch
                    recommend_output = self.model.finetune(input_ids) # return hidden states
                    recommend_output = recommend_output[:, -1, :] # transformer의 마지막 Sequence값

                    rating_pred = self.predict_full_attribute(recommend_output, attribute) # item embedding.weight+attribute embedding.weight과 matmul

                    rating_pred = rating_pred.cpu().data.numpy().copy()
                    batch_user_index = user_ids.cpu().numpy()
                    rating_pred[self.args.train_matrix[batch_user_index].toarray() > 0] = 0 # train에 사용한 것들 = 0
                    # reference: https://stackoverflow.com/a/23734295, https://stackoverflow.com/a/20104162
                    # argpartition 时间复杂度O(n)  argsort O(nlogn) 只会做
                    # 加负号"-"表示取大的值
                    ind = np.argpartition(rating_pred, -k)[:, -k:] # train에 사용한 것 제외하고 상위 20개 인덱스
                    arr_ind = rating_pred[np.arange(len(rating_pred))[:, None], ind]
                    arr_ind_argsort = np.argsort(arr_ind)[np.arange(len(rating_pred)), ::-1]
                    batch_pred_list = ind[np.arange(len(rating_pred))[:, None], arr_ind_argsort]

                    if i == 0:
                        pred_list = batch_pred_list
                    else:
                        pred_list = np.append(pred_list, batch_pred_list, axis=0)
                
                        
                    # pred_list : inference 결과(index) / shape: (num_user x 20)
                # return self.get_full_sort_score(epoch, answer_list, pred_list)
            return pred_list
            