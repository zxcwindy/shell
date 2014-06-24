#!/bin/sh
hostalias="134 41 166 164"
hosts=(10.112.1.134 10.112.8.41 10.109.208.166 10.109.208.164)
users=(aiapp ocdc  ocdc ocdc)
passwords=(aiapp123 abc@123 1qazxsw2 1qazxsw2)
index=0
position=-1
for ip in $hostalias
do
    if [ $1 = $ip ]
    then
	position=$index
    fi
    (( index = index + 1))
done

if [ "$position" -ne  "-1" ]
then
    expect -c "
spawn ssh db2inst1@10.95.239.158
expect {
\"fj_test*\" {send \"ssh ${users[position]}@${hosts[position]}\r\";exp_continue}
\"*assword*\" { send \"${passwords[position]}\r\";interact}
}
"
fi

if [ "$position" -eq "-1" ]
then

    hostalias1="116 117 118 119"
    hosts1=(10.112.1.116 10.112.1.117 10.112.1.118 10.112.1.119)
    users1=(ocdc ocdc ocdc ocdc)
    passwords1=(abc@123 abc@123 abc@123 abc@123)
    index1=0
    position1=0
    for ip in $hostalias1
    do
	if [ $1 = $ip ]
	then
	    position1=$index1
	fi
	(( index1 = index1 + 1))
    done
    expect -c "
spawn ssh db2inst1@10.95.239.158
expect {
\"fj_test*\" {send \"ssh ${users1[position1]}@${hosts1[position1]}\r\";interact}
}
"
fi
