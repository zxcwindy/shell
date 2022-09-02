#!/bin/bash
export COLUMNS=500

# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

RED='\033[0;31m'
NC='\033[0m' # No Color

IFS=$'\n'
temp_result=($(ps -ef|grep "$1" |grep -v grep | grep -v kk))
if [ "${#temp_result[@]}" -gt "0" ]
then
    index_=1
    for result in "${temp_result[@]}"; do
	echo -e "${RED}$index_  ${NC}$result"
	index_=`expr $index_  + 1`
    done
    read -p "kill第n个进程(1,2,...) 退出不做操作(n)：" yes_or_no
    if [ "$yes_or_no" == "n" ]
    then
	echo "cancel"
    else
	tmp_id=`echo "${temp_result[$yes_or_no-1]}" | awk '{print $2}'`
	kill -9 "$tmp_id"
    fi

else
    echo "没找到对应进程"
fi
