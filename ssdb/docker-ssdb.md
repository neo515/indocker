### 227: ssdb
```shell
1. 编译ssdb的docker镜像
# Dockerfile: /data/yunwei/script/ssdb_image
docker build -t ssdb:1.9.2 .   #build镜像

2. 建立ssdb容器(共21个)
port=8889
docker run  --restart=always --name ssdb_${port} -h ssdb_${port} \
        -v /data/yunwei/data/ssdb_${port}:/ssdb/var  -v /data/yunwei/etc/ssdb/prod.conf:/ssdb/ssdb.conf \
        -v /etc/localtime:/etc/localtime \
        -p ${port}:8888 -tid ssdb:1.9.2

3. 维护
data目录: /data/yunwei/data/
配置文件:  /data/yunwei/etc/ssdb/prod.conf
连接: ssdb-cli -h 127.0.0.1 -p $port
启动/停止:  docker start ssdb_$port  / docker  stop ssdb_$port
```
