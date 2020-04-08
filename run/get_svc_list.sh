#!/bin/bash

svc=$1

if [ x"$svc" == 'x' ];then
    docker ps -a -f "label=creator=indocker"
else
    docker ps -a -f "label=creator=indocker" |grep $svc || echo "未找到"
fi