#!/bin/bash
source config.sh

read -p '请输入你要使用的端口: ' port
# port=11211
docker run --restart=always  \
    --name memcached-${port} \
    -h     memcached-${port} \
    -p ${port}:11211 -tid  \
    memcached:1.4.24 memcached -m 512
    # -v /etc/localtime:/etc/localtime \