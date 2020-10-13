#### 说明
起初,在公司的内网有一台服务器用来存放一些数据所用. 随着时间推移,之后这个机器上就被启动了各种数据库服务,无论是mysql还是nosql系都有. 后来发现管理上比较混乱,也不知道开通了什么,所以开始着手整理这些数据库服务.

之前的服务都是通过二进制的方式启动（rpm和编译方式都有）, 也发现多个mysql的时候,存在不好管理的问题.总要去考虑我连接的是谁, mysql的目录是哪里,就很是头疼. 所以我决定切成用docker去处理这些数据库服务.

花了一些时间,整理数据、迁移数据、修改业务代码数据库指向,折腾了一通,终于迁移到docker上. 其中mysql迁移为了保证安全采用了做主从的方式来迁移.

后来一共整理了数据库服务统计如下
```
mysql: 4个
redis: 52个
ssdb:  21个
memcached: 4个
mongodb:   1个
```
到此,这些数据库服务的管理终于舒服了很多, 也有了一个比较明晰的清单列表.

#### 使用场景说明
- 由于这个专用数据库服务器配置比较高,可以承载那么多的服务; 如果你的机器性能不是很足, 酌情控制服务的数量或者在其他机器上做.  
- 该项目也只是简单管理下单机上的数据库服务,主要是为了解决快速使用上的问题,所以没有多机使用啥啥啥的一系列考虑,请知晓

#### 让我们开始
1. 当然,找个目录clone下来吧.
```
git clone https://github.com/neo515/indocker.git
```

2. 简单配置下就可以正常用啦
```
vim run/config.sh
svc_path=/Data/service   #修改这个变量

# 之后的生成的所有数据库服务的家目录是放到这里 
# 注意等号两边不要有空格
```

3. 生成ssdb的镜像（可选,不需要ssdb就跳过）
```
# ssdb官方没有提供镜像, 我们自己build一个.
cd make_images/ssdb
docker build -t ssdb:1.9.2 .  # build镜像
docker images |grep ssdb      # 确认是否生成
```

4. 至此,可以愉快的玩耍了. 
目前支持生成的服务有:mysql,mongodb,memcached,redis,ssdb.
```
# 举例开启一个端口3308的mysql
$> cd run/
$> bash creat_mysql.sh
请输入你要使用的端口: 3308      #询问我们要建立的mysql的端口
bf5fb40048ee8305b526a02d2779b7d0bf36cc963a2d3fa55d98e907d65f7196
$> docker ps |grep mysql
bf5fb40048ee   mysql:5.6.39   "docker-entrypoint.s…"   Up 22 seconds  0.0.0.0:3308->3306/tcp   mysql-3308

$> mysql -h 127.0.0.1 -uroot -proot -P 3308 -A                                                                        [15:44:04]
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2

Server version: 5.6.39-log MySQL Community Server (GPL)

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
3 rows in set (0.04 sec) 
```

5. 如何获取当前创建了哪些服务呢?
```
cd run
bash get_svc_list.sh   #无参时,获取所有indocker创建的服务
bash get_svc_list.sh   mysql   #获取指定的服务

$> bash get_svc_list.sh
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                      NAMES
d8cb34114d65        redis:3.0.5         "/entrypoint.sh /usr…"   2 minutes ago       Up 2 minutes        0.0.0.0:6382->6379/tcp     redis-6382
a8d0e0e022cb        redis:3.0.5         "/entrypoint.sh /usr…"   2 minutes ago       Up 2 minutes        0.0.0.0:6381->6379/tcp     redis-6381
7f4962f0fbf8        mysql:5.6.39        "docker-entrypoint.s…"   3 minutes ago       Up 3 minutes        0.0.0.0:3310->3306/tcp     mysql-3310
746fa33061e9        mysql:5.6.39        "docker-entrypoint.s…"   3 minutes ago       Up 3 minutes        0.0.0.0:3309->3306/tcp     mysql-3309
876ab41d182a        memcached:1.4.24    "/entrypoint.sh memc…"   10 minutes ago      Up 10 minutes       0.0.0.0:11111->11211/tcp   memcached-11111

$> bash get_svc_list.sh mysql 
7f4962f0fbf8        mysql:5.6.39        "docker-entrypoint.s…"   3 minutes ago       Up 3 minutes        0.0.0.0:3310->3306/tcp     mysql-3310
746fa33061e9        mysql:5.6.39        "docker-entrypoint.s…"   3 minutes ago       Up 3 minutes        0.0.0.0:3309->3306/tcp     mysql-3309

$> bash get_svc_list.sh redis
d8cb34114d65        redis:3.0.5         "/entrypoint.sh /usr…"   2 minutes ago       Up 2 minutes        0.0.0.0:6382->6379/tcp     redis-6382
a8d0e0e022cb        redis:3.0.5         "/entrypoint.sh /usr…"   2 minutes ago       Up 2 minutes        0.0.0.0:6381->6379/tcp     redis-6381
```

6. 服务的数据存放在哪  
```
$> cd /Data/service   # 这个目录就是第二步中config.sh文件中配置的svc_path变量
$> ll 
drwxr-xr-x  5 jerry  admin  160  4  8 01:28 mongodb-1111
drwxr-xr-x  4 jerry  admin  128  4  8 15:40 mysql-3308
drwxr-xr-x  5 jerry  admin  160  4  8 01:34 mysql-3309
drwxr-xr-x  4 jerry  admin  128  4  8 15:59 mysql-3310
drwxr-xr-x  5 jerry  admin  160  4  8 01:14 redis-6380
drwxr-xr-x  4 jerry  admin  128  4  8 15:59 redis-6381
drwxr-xr-x  4 jerry  admin  128  4  8 15:59 redis-6382
drwxr-xr-x  5 jerry  admin  160  4  8 01:32 redis-8123
drwxr-xr-x  5 jerry  admin  160  4  8 01:13 ssdb-8888
drwxr-xr-x  4 jerry  admin  128  4  8 01:33 ssdb-9999

$> tree redis-6382  
redis-6382
├── data
│   ├── dump.rdb
│   └── redis.log
└── etc
    └── redis.conf

ps: 其他服务类似
```

7. 后记

该小项目一直也是在完善中, 以后也将添加一些其他的服务.  
推荐和portainer一起使用
