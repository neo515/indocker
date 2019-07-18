### 227: memcached
```shell
建立memcached
port=11211
docker run  --restart=always --name memcached_${port} -h memcached_${port} \
    -v /etc/localtime:/etc/localtime \
    -p ${port}:11211 -tid  memcached:1.4.24  memcached -m 512

ps: 不需要另外的配置文件
```
