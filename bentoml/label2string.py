import os
import pickle

import numpy as np


def track(pred_result, args):

    id2track_path = args.data_dir + args.data_name + "/artifacts/"
    # load prediction result(.npy)
    # with open(pred_list_dir, "rb") as f:
    #     pred_list = np.load(f, allow_pickle=True)
    # load dictionary(.pkl)
    with open(id2track_path + "id2track_dict.pkl", "rb") as f:
        id2track_dict = pickle.load(f)

    track_pred_list = np.vectorize(id2track_dict.get)(pred_result)

    return track_pred_list


def user(pred_result, args):

    id2user_path = args.data_dir + args.data_name + "/artifacts/"
    # load prediction result(.npy)
    # with open(pred_list_dir, "rb") as f:
    #     pred_list = np.load(f, allow_pickle=True)
    # load dictionary(.pkl)
    with open(id2user_path + "id2user_dict.pkl", "rb") as f:
        id2user_dict = pickle.load(f)

    user_name_list = np.vectorize(id2user_dict.get)(pred_result)

    return user_name_list
