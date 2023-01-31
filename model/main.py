from mlflow import log_metric, log_param, log_artifacts
import os

if __name__ == "__main__" : 
    
    if not os.path.exists("./outputs") : 
        os.makedir("outputs")
    with open("outputs/test.txt", "w") as f: 
        f.write("hello world!")
        
    log_artifacts("outputs")