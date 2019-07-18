### 227: mysql
```shell
1. mysql的启动
# 第一次初始化mysql时, 不要建立datadir目录(mysql1). 让docker自己生成.否则识别为已存在的db,不会自动初始化
docker run  --restart=always --name mysql1 -h mysql1 \
        -v /data/yunwei/data/mysql1:/var/lib/mysql \
        -v /data/yunwei/etc/mysql:/etc/mysql/conf.d  \
        -v /etc/localtime:/etc/localtime \
        -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 -tid mysql:5.6.39

docker run  --restart=always --name mysql2 -h mysql2 \
        -v /data/yunwei/data/mysql2:/var/lib/mysql  \
        -v /data/yunwei/etc/mysql:/etc/mysql/conf.d  \
        -v /etc/localtime:/etc/localtime \
        -e MYSQL_ROOT_PASSWORD=root -p 3307:3306 -tid mysql:5.6.39

2. 管理维护
连接: mysql -h127.0.0.1 -u root -proot -P 3306/3307
配置文件: /data/yunwei/etc/mysql/my.cnf  # 如若修改配置,重启mysql的容器生效(docker stop/start)
db目录分别在 /data/yunwei/data/mysql1  /data/yunwei/data/mysql2
日志: 分别在db data目录下(/data/yunwei/data/mysql1/2)

ps: mysql的配置文件最好单独配置，公用一个可能会影响使用体验

```
