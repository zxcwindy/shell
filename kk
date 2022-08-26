#!/bin/bash
# export COLUMNS=500
IFS=$'\n'
temp_result=($(ps -ef|grep "$1" |grep -v grep | grep -v kk))
if [ "${#temp_result[@]}" -gt "0" ]
then
    echo "${temp_result[*]}"
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
