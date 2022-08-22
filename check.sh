#!/bin/bash

n1="
"

if [[ "$*" == *"$n1"* ]]
then
    # IFS=$' ' array=($(mvn dependency:tree | grep "^\[INFO\].*:jar:" | awk -F: '{print $2"-"$4".jar"}')) ; /home/david/work/bmsoft/huawei/安红测试/check.sh ${array[@]}
    IFS=$'\n' targetJars=($*)
    cd `dirname $0`
    readarray -t unsafeJars < unsafe-jar-list
    for((i=0;i<${#targetJars[@]};i++)); do
	if [[ " ${unsafeJars[*]} " =~ "${targetJars[$i]}" ]]
	then
	    echo "${targetJars[$i]}"
	fi
    done
else
    targetJars=$(find $1 -name "*jar")
    cd `dirname $0`
    readarray -t unsafeJars < unsafe-jar-list
    for targetjar in $targetJars; do
	jarname=$(echo "${targetjar}" | sed -n "s/^.*\/\(.*\)$/\1/p")
	if [[ " ${unsafeJars[*]} " =~ " ${jarname} " ]]
	then
	    echo "${targetjar}"
	fi
    done
fi
