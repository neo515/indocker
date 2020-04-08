#!/bin/bash


svc_path=/Volumes/Data/service    #修改成你准备放置数据库服务的根目录,如/data/services/

###################################################

project_path=$(dirname $(cd `dirname $0`;pwd))

cfg_tmpl_path=${project_path}/conf_tmpl
