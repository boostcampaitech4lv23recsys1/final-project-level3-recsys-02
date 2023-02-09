import pandas as pd
import psycopg2

db_connect = psycopg2.connect(
    user="myuser",
    password="mypassword",
    host="34.64.50.61",
    port=5432,
    database="mydatabase",
)


df = pd.read_sql("select * from inter;", db_connect)
df["track_tuple"] = [
    (df["track_name"][i], df["artist_name"][i]) for i in range(df.shape[0])
]
tracks = {
    i: np.unique(df["track_tuple"])[i]
    for i in range(np.unique(df["track_tuple"]).shape[0])
}
with open(file="id2track_artist_dict.pickle", mode="wb") as f:
    pickle.dump(tracks, f)
