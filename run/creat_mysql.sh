#!/bin/bash
source config.sh

read -p '请输入你要使用的端口: ' port

service_name=mysql
# svc_path=/Data/service  #config.sh

service_path=${svc_path}/${service_name}-${port}  # eg: /Data/service/mysql-3307
mkdir -p ${service_path}   # eg: /Data/service/mysql-3307

service_data=${service_path}/data  # eg: /Data/service/mysql-3307/data
service_etc=${service_path}/etc    # eg: /Data/service/mysql-3307/etc

cp -r ${cfg_tmpl_path}/${service_name}/ $service_etc
mkdir -p  $service_etc/conf.d/

# 新建立时会自动进行初始化，不要建立datadir目录(mysql1)， 让docker自己生成；
# 否则识别为已存在的db,不会自动初始化
# port=3306

docker run  --restart=always \
    --name ${service_name}-${port} \
    -h ${service_name}-${port} \
    --memory 4G \
    -v ${service_data}:/var/lib/mysql \
    -v ${service_etc}:/etc/mysql \
    -e MYSQL_ROOT_PASSWORD=root \
    -p ${port}:3306 \
    -l creator=indocker \
    -tid mysql:5.6.39

    # -v /etc/localtime:/etc/localtime  \  #mac上dockerd服务需要开启目录权限才能映射,所以mac取消映射localtime
    # -v ${service_etc}/my.cnf:/etc/mysql/my.cnf \
    # -v ${service_etc}/conf.d/:/etc/mysql/conf.d \

