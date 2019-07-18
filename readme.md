#### 0.目录规范
/data/yunwei/data/  
/data/yunwei/etc/

*|配置文件 | 数据目录| 日志路径
---|---|---|---
mongodb  |etc/mongodb/mongod.conf | data/mongodb/mongodb-${port}  |data/mongodb/mongodb-${port}/mongodb.log
ssdb     |etc/ssdb/prod.conf      | data/ssdb/var-${port}         |data/ssdb/var-${port}/ssdb.log
memcached|etc/ssdb/prod.conf      |                               | 
mysql    |etc/mysql/my.cnf        | data/mysql${port}             |data/mysql${port}/mysql${port}.log
redis    |etc/redis/redis.conf    | data/redis/redis-${port}      |data/redis/redis-${port}/redis.log


`ps：相对于/data/yunwei/`

#### 1.mongodb
配置文件(容器共用)：  /data/yunwei/etc/mongodb/mongod.conf  
每个容器对应数据目录： /data/yunwei/data/mongodb/mongodb-${port}  
日志：              /data/yunwei/data/mongodb/mongodb-${port}/mongodb.log  

```bash
# 建立mongodb
port=27017

docker run --restart=always \
    --name mongodb-${port}  \
    -h     mongodb-${port}  \
    -v /data/yunwei/data/mongodb/mongodb-${port}:/data/db \
    -v /data/yunwei/etc/mongodb:/etc/mongo \
    -v /etc/localtime:/etc/localtime \
    -p ${port}:27017 -tid \
    mongo:3.4.10 --config /etc/mongo/mongod.conf
```

#### 2.ssdb
1.ssdb dockerfile  
`# docker build -t ssdb:1.9.2 .  # 官方没有提供ssdb的镜像`  
2.配置  
配置文件(容器共用):  /data/yunwei/etc/ssdb/prod.conf  
每个容器对应数据目录: /data/yunwei/data/ssdb/var-${port}  
日志：              /data/yunwei/data/ssdb/var-${port}/ssdb.log  
```bash
建立新的ssdb服务
port=8889
docker run  --restart=always \
    --name ssdb_${port} \
    -h     ssdb_${port} \
    -v /data/yunwei/data/ssdb_${port}:/ssdb/var  \
    -v /data/yunwei/etc/ssdb/prod.conf:/ssdb/ssdb.conf \
    -v /etc/localtime:/etc/localtime \
    -p ${port}:8888 -tid \
    ssdb:1.9.2
```

#### 3.memcached
```bash
建立memcached
port=11211
docker run --restart=always  \
    --name memcached_${port} \
    -h     memcached_${port} \
    -v /etc/localtime:/etc/localtime \
    -p ${port}:11211 -tid  \
    memcached:1.4.24 memcached -m 512
```
ps: memcached没有使用配置文件

#### 4.mysql
配置文件(容器共用):  /data/yunwei/etc/mysql/my.cnf  
每个容器对应数据目录: /data/yunwei/data/mysql${port}  
日志：  /data/yunwei/data/mysql${port}/mysql${port}.log  
```bash
# 新建立时会自动进行初始化，不要建立datadir目录(mysql1)， 让docker自己生成；
# 否则识别为已存在的db,不会自动初始化
port=3306
docker run  --restart=always \
    --name mysql${port} \
    -h mysql${port} \
    --memory 4G \
    -v /data/yunwei/data/mysql${port}:/var/lib/mysql \
    -v /data/yunwei/etc/mysql:/etc/mysql/conf.d  \
    -v /etc/localtime:/etc/localtime \
    -e MYSQL_ROOT_PASSWORD=root \
    -p ${port}:3306 \
    -tid mysql:5.6.39
```
ps: mysql的配置文件最好单独配置，共用一个可能会导致无法单独修改某些mysql服务的配置

#### 5.redis
配置文件(容器共用):  /data/yunwei/etc/redis/redis.conf  
每个容器对应数据目录: /data/yunwei/data/redis/redis-${port}  
日志： /data/yunwei/data/redis/redis-${port}/redis.log  

```bash
# 建立memcached
port=9100
docker run --restart=always \
    --name redis_${port}  \
    -h redis_${port} \
    -v /data/yunwei/data/redis/redis-${port}:/data \
    -v /data/yunwei/etc/redis/redis.conf:/usr/local/etc/redis/redis.conf \
    -v /etc/localtime:/etc/localtime \
    -p $port:6379   -tid  redis:3.0.5 \
    /usr/local/bin/redis-server /usr/local/etc/redis/redis.conf
```


