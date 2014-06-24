#!/bin/sh
hostalias="203 204 8 7 53 3 158 12 47 172-1 172 10 11 5"
hosts=(192.168.1.203 192.168.1.204 10.109.1.8 10.109.1.7 10.105.4.53 192.168.0.3 10.95.239.158 10.5.18.12 112.124.104.47 10.25.125.172 10.25.125.172 10.5.18.10 10.5.1.11 10.161.252.5)
users=(webdb root aiapp aiweb kpi root db2inst1 ocdc root hbsale doota ocdc svn doota)
index=0
position=0
for ip in $hostalias
do
    if [ $1 = $ip ]
    then
	position=$index
    fi
    (( index = index + 1))
done

ssh ${users[position]}@${hosts[position]}
