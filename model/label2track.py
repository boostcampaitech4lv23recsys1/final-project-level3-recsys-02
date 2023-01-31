import numpy as np
import pandas as pd
import pickle
import os

def main(pred_result, load=False) : 
    
    id2track_path = "./data/bk100/artifacts/"
    latest_result = os.path.join(id2track_path, os.listdir(id2track_path)[-1])
    with open(latest_result, "rb") as f:
        id2track_dict = pickle.load(f)
        
    if load :
        pred_path = "./output/pred_list"
        latest_pred_result = os.path.join(pred_path, os.listdir(pred_path)[-1])
        result = np.load(latest_pred_result)
        
    else : 
        result = pred_result
        
    track_pred_list = np.vectorize(id2track_dict.get)(result)
    
    return track_pred_list
    
        



