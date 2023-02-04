# bento_service.py
# import time

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

@env(infer_pip_packages=True)
@artifacts([MyModelArtifact("test_model")])
class MyService(bentoml.BentoService):
    @api(input=StringInput(), batch=False)
    def recomendation_music(self, input_data):
        args = self.artifacts.test_model["args"]
        username = int(input_data)

        df = pd.read_sql(f"select * from inter where user_id = {username};", db_connect)
        
        user_seq = list(df.sort_values(by = ['date_uts']).groupby(by= ['user_id'])['track_id'].apply(list).reset_index(drop=True))
        #user_seq = [[i for i in range(50)]]

        infer_dataset = SASRecDataset(args, user_seq, data_type="infer")
        infer_dataloader = DataLoader(infer_dataset, batch_size=args.batch_size)
        
        predictor = Predictor(self.artifacts.test_model["S3Rec"], infer_dataloader, args)

        main_pred_list = predictor.get_topk_main(username, full_sort=True)
        tag_pred_list = predictor.get_topk_tag(0, 0,full_sort=True) # 추천 태그 정하는 방법에 대해
        artist_pred_list = predictor.get_topk_artist(0, 0,full_sort=True) # 추천 아티스트 정하는 방법에 대해
        self.artifacts.test_model["pred_list"][username] = main_pred_list
        

        main_query = f"""select track_info.track_id, album_info.image, track_info.track_name, track_info.album_name, track_info.artist_name, track_info.duration from track_info left outer join album_info on track_info.album_name = album_info.album_name where (track_info.track_id in {tuple(main_pred_list[0])});"""
        tag_pred_list = f"""select track_info.track_id, album_info.image, track_info.track_name, track_info.album_name, track_info.artist_name, track_info.duration from track_info left outer join album_info on track_info.album_name = album_info.album_name where (track_info.track_id in {tuple(tag_pred_list[0])});"""
        artist_pred_list = f"""select track_info.track_id, album_info.image, track_info.track_name, track_info.album_name, track_info.artist_name, track_info.duration from track_info left outer join album_info on track_info.album_name = album_info.album_name where (track_info.track_id in {tuple(artist_pred_list[0])});"""
        
        output = {'main':-1, 'tag':-1, 'artist':-1}
        with db_connect.cursor() as cur:
            for index, query in enumerate([main_query, tag_pred_list, artist_pred_list]):
                cur.execute(query)
                output[list(output.keys())[index]] = cur.fetchall()
        return output

    @api(input=StringInput(), batch=False)
    def recomendation_user(self, input_data):
        args = self.artifacts.test_model["args"]
        username = int(input_data)

        df = pd.read_sql(f"select * from inter where user_id = {username};", db_connect)
        
        user_seq = list(df.sort_values(by = ['date_uts']).groupby(by= ['user_id'])['track_id'].apply(list).reset_index(drop=True))

        infer_dataset = SASRecDataset(args, user_seq, data_type="infer")
        infer_dataloader = DataLoader(infer_dataset, batch_size=args.batch_size)
        
        predictor = Predictor(self.artifacts.test_model["S3Rec"], infer_dataloader, args)
        user = predictor.get_topk_users(username, self.artifacts.test_model["pred_list"])

        user_query = f'select user_id, realname, image, following, follower, user_name from user_info where user_id in {tuple(user)};'
        with db_connect.cursor() as cur:
            cur.execute(user_query)
            values = cur.fetchall()

        return values