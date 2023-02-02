# bento_service.py
import argparse
import os
import time

import bentoml
import pandas as pd
import psycopg2
from bentoml import BentoService, api, artifacts, env
from bentoml.adapters import StringInput
from my_model_artifact import MyModelArtifact
from torch.utils.data import DataLoader

from datasets import SASRecDataset
from predictor import Predictor
from models import S3RecModel

db_connect = psycopg2.connect(
    user="myuser",
    password="mypassword",
    host="34.64.50.61",
    port=5432,
    database="mydatabase",
)

class class_args():
    def __init__(self):
        self.train_matrix = [int]


@env(infer_pip_packages=True)
@artifacts([MyModelArtifact("test_model")])
class MyService(bentoml.BentoService):
    @api(input=StringInput(), batch=False)
    def predict_user(self, input_data):
        username = int(input_data)
        args = self.artifacts.test_model["S3Rec"].args

        df = pd.read_sql(f"select * from inter where user_id = {username};", db_connect)
        
        user_seq = list(df.sort_values(by = ['date_uts']).groupby(by= ['user_id'])['track_id'].apply(list).reset_index(drop=True))
        
        infer_dataset = SASRecDataset(args, user_seq, data_type="infer")

        #checkpoint = "/opt/ml/final-bentoml/output/Finetune_full-kdy_kdy1000-10.pt"
        infer_dataloader = DataLoader(infer_dataset, batch_size=args.batch_size)
        
        predictor = Predictor(self.artifacts.test_model["S3Rec"], infer_dataloader, args)
        #predictor.load(os.path.join(args.output_dir, checkpoint))


        pred_list = predictor.get_topk_main(0, full_sort=True)
        #pred_list = predictor.get_topk_tag(0, full_sort=True)
        #pred_list = predictor.get_topk_artist(0, full_sort=True)
        #pred_list = predictor.get_topk_users(0, full_sort=True)

        query = f"""select album_info.image, track_info.track_name, track_info.album_name, track_info.artist_name, track_info.duration from track_info left outer join album_info on track_info.album_name = album_info.album_name where (track_info.track_id in {tuple(pred_list[0])});"""
        
        with db_connect.cursor() as cur:
            cur.execute(query)
            values = cur.fetchall()
        return values
