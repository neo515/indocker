### 227: redis
```shell
1. 建立redis
port=9100
docker run --restart=always --name redis_$port  -h redis_$port \
-v /data/yunwei/data/redis/redis-$port:/data \
-v /data/yunwei/etc/redis/redis.conf:/usr/local/etc/redis/redis.conf \
-v /etc/localtime:/etc/localtime \
-p $port:6379   -tid  redis:3.0.5 /usr/local/bin/redis-server /usr/local/etc/redis/redis.conf

2. 维护
data:  /data/yunwei/data/redis/
配置文件: /data/yunwei/etc/redis/redis.conf
连接: redis-cli  -h 127.0.0.1 -p $port
```
