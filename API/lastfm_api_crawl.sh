#! /bin/bash

user=$1
api=`cat api_key`
ver=$2
user_sampling=$3

echo "user = $user"
echo "$api"
echo "ver = $ver"
echo "user_sampling = $user_sampling"

echo "phase 1"
python lastfm_api_crawl.py --user $user --api $api --ver $ver --user_sampling $user_sampling --phase 1
echo "phase 2"
python lastfm_api_crawl.py --user $user --api $api --ver $ver --phase 2