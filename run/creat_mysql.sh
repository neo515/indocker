#!/bin/bash
source config.sh

read -p '请输入你要使用的端口: ' port

service_name=mysql
# mongodb_main_path=${svc_path}/mongodb-${port}
service_path=${svc_path}/${service_name}-${port}
service_data=${service_path}/data
service_etc=${service_path}/etc

mkdir -p ${service_path}
cp -r ${cfg_tmpl_path}/${service_name} $service_etc

# 新建立时会自动进行初始化，不要建立datadir目录(mysql1)， 让docker自己生成；
# 否则识别为已存在的db,不会自动初始化
# port=3306

docker run  --restart=always \
    --name ${service_name}-${port} \
    -h ${service_name}-${port} \
    --memory 4G \
    -v ${service_data}:/var/lib/mysql \
    -v ${service_etc}:/etc/mysql/conf.d  \
    -e MYSQL_ROOT_PASSWORD=root \
    -p ${port}:3306 \
    -l creator=indocker \
    -tid mysql:5.6.39
    # -v /etc/localtime:/etc/localtime \