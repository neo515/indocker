#!/bin/bash
source config.sh

read -p '请输入你要使用的端口: ' port

# ssdb_data=${data_path}/ssdb/ssdb-${port}
# ssdb_etc=${etc_path}/ssdb/ssdb.conf

service_name=ssdb
# mongodb_main_path=${svc_path}/mongodb-${port}
service_path=${svc_path}/${service_name}-${port}
service_data=${service_path}/data
service_etc=${service_path}/etc/

mkdir -p ${service_path}
cp -r ${cfg_tmpl_path}/${service_name} $service_etc


# port=8889
docker run  --restart=always \
    --name ${service_name}-${port} \
    -h     ${service_name}-${port} \
    -v ${service_data}:/ssdb/var  \
    -v ${service_etc}/ssdb.conf:/ssdb/ssdb.conf \
    -p ${port}:8888 -tid \
    ssdb:1.9.2
    # -v /etc/localtime:/etc/localtime \