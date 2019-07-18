### 227: mongodb
```shell
1. 建立mongodb
port=27017

docker run --restart=always --name mongodb-$port -h mongodb-$port \
    -v /data/yunwei/data/mongodb/mongodb-$port:/data/db \
    -v /data/yunwei/etc/mongodb:/etc/mongo \
    -v /etc/localtime:/etc/localtime \
    -p $port:27017 -tid mongo:3.4.10 --config /etc/mongo/mongod.conf



2. 维护
data:  /data/yunwei/data/mongodb/mongodb-$port
配置文件: /data/yunwei/etc/mongodb/mongod.conf
```
