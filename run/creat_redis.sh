#!/bin/bash
source config.sh

read -p '请输入你要使用的端口: ' port

# redis_data=${data_path}/redis/redis-${port}
# redis_etc=${etc_path}/redis/redis.conf

service_name=redis
# mongodb_main_path=${svc_path}/mongodb-${port}
service_path=${svc_path}/${service_name}-${port}
service_data=${service_path}/data
service_etc=${service_path}/etc/

mkdir -p ${service_path}
cp -r ${cfg_tmpl_path}/${service_name} $service_etc

# port=9100
docker run --restart=always \
    --name ${service_name}-${port}  \
    -h ${service_name}-${port} \
    -v ${service_data}:/data \
    -v ${service_etc}:/usr/local/etc/redis/ \
    -p $port:6379   -tid  redis:3.0.5 \
    /usr/local/bin/redis-server /usr/local/etc/redis/redis.conf
    # -v /etc/localtime:/etc/localtime \