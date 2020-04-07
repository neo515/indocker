#!/bin/bash

source config.sh

read -p '请输入你要使用的端口: ' port
# port=27017
service_name=mongodb
# mongodb_main_path=${svc_path}/mongodb-${port}
service_path=${svc_path}/${service_name}-${port}
service_data=${service_path}/data
service_etc=${service_path}/etc

mkdir -p ${service_path}
cp -r ${cfg_tmpl_path}/${service_name} $service_etc


docker run --restart=always \
    --name ${service_name}-${port}  \
    -h     ${service_name}-${port}  \
    -v ${service_data}:/data/db \
    -v ${service_etc}:/etc/mongo \
    -p ${port}:27017 -tid \
    mongo:3.4.10 --config /etc/mongo/mongod.conf

    # -v /etc/localtime:/etc/localtime \