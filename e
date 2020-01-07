#!/bin/sh
# 将~/.ssh/config中的文件集合为　"129hadoop 192.168.0.129 hadoop" 的形式打印
# 自动补全获取数组  sed -n '4,$ p' ./config | sed  -n '1h;1!H;$g;s/\n/ /g;s/Host /\nHost /g;$p' | sed '/^$/d' | awk '{for (i = 1; i<NF; i++) if ($i == "Host") printf $(i+1) " ";else if ($i == "HostName") printf $(i+1) " ";else if ($i == "User") print $(i+1);}'
# sed -n "/10.5.1.44/,/User / p" ~/.ssh/config  | sed -n "N;s/\n/ /;s/HostName //;s/User //; p"
eTempHost=$1
eUser=""
eHost=""
fullHostRegex="([0-9]{1,3}\.){3}([0-9]{1,3})"
eOutput="/home/david/.ssh/config"
eSshConfigFiel="/home/david/.ssh/config"
eIsAdd=false
eIsError=false

_eOutput(){
    eHostName=${eHost##*.}
    tempHostResult=$(sed -n "/Host $eHostName$/ p" $eSshConfigFiel)
    if [ -n "$tempHostResult" ]
       then
	   eHostName="$eHostName$eUser"
	   tempHostResult=$(sed -n "/Host $eHostName$/ p" $eSshConfigFiel)
	   if [ -n "$tempHostResult" ]
	      then
		  eHostName="$eUser@$eHost"
	   fi
    fi
    echo " " >> $eOutput
    echo "Host $eHostName" >> $eOutput
    echo "ServerAliveInterval 5" >> $eOutput
    echo "HostName $eHost" >> $eOutput
    echo "User $eUser" >> $eOutput
    echo "port 22" >> $eOutput
}

_eError(){
    eIsError=true
    echo "主机->$eHost 未知的用户->$eUser"
}

# 当参数为 xxx@a.b.c.d时，判断ssh缩写是否存在，不存在则写入
# 当参数为 xxx@aaa时，判断ssh缩写是否存在，不存在则提示错误
# 当参数为 aaa时，判断ssh缩写是否存在，不存在则提示错误
_ePreSsh(){
    eSplitKey="@"
    if [[ $eTempHost =~ $eSplitKey ]]
    then
	eUser=${eTempHost%@*}
	eHost=${eTempHost#*@}
	if [[ $eHost =~ $fullHostRegex ]]
	then
	    hostNameResult=$(sed -n "/$eHost/,/User / p" $eSshConfigFiel  | sed -n "N;s/\n/ /;s/HostName //;s/User //; p")
	    if ! [[ $hostNameResult =~ $eHost ]] || ! [[ $hostNameResult =~ $eUser ]]
	    then
		eIsAdd=true
	    fi
	else
	    hostResult=$(sed -n "/Host $eHost/,/User / p" $eSshConfigFiel | sed -n "4 p")
	    if ! [[ $hostResult =~ $eUser ]]
	    then
		_eError
		return
	    fi
	fi
    else
	eHost=$eTempHost
	hostResult=$(sed -n "/Host $eHost/ p" $eSshConfigFiel)
	if [ -z "$hostResult" ]
	then
	    _eError
	fi

    fi

}

_ePreSsh

if [ $eIsAdd == true ]
then
    cat ~/.ssh/id_rsa.pub | ssh $eTempHost 'cat - >> ~/.ssh/authorized_keys;chmod 700 ~/.ssh;chmod 600 ~/.ssh/authorized_keys'
    _eOutput
fi

if [ $eIsError == false ]
then
    ssh $eTempHost
fi
