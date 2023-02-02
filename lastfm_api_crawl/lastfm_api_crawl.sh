#! /bin/bash

user=$1
api=`cat api_key`
ver=$2
user_sampling=$3
skip=$4

echo "user = $user"
echo "$api"
echo "ver = $ver"
echo "user_sampling = $user_sampling"

if [ $skip -eq 0 ]
then
    echo "phase 1"
    python lastfm_api_crawl.py --user $user --api $api --ver $ver --user_sampling $user_sampling --phase 1
fi
echo "phase 2"
python lastfm_api_crawl.py --user $user --api $api --ver $ver --user_sampling $user_sampling --phase 2