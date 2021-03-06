#!/bin/bash 
#we save to variable name of file with list of server 
serverlist='server_list.txt' 
#we save to variable list of servers from file 
servers=`cat $serverlist`
#we save in variable name of file with results 
result='result.txt' 
#we get each server from servers variable 
for server in $servers 
do 
#Printing servername to result file echo -e "$server"> $result #getting list of ethernet links via ifconfig command, and from all output we need onlu lines that have word link and starting with [a-z][a-z]*[0-9], and after we get first word from output
ips=`ssh root@${server{ "ifconfig -a | grep -o -e '[a-z][a-z]*[0-9]*[ ]*Link' |grep -v lo| perl -pe 's|^([a-z]*[0-9]*)[ ]*Link|\1|'"`
for ip in $ips 
do 
#we get ips, via ifconfig command, and grepping for inet addr script.
INET=`ssh root${server} "ifconfig $ip |grep -o -e 'inet addr:[^ ]*' | grep -o -e '[^:]*$'"` 
#same for mask 
MASK=`ssh $server "ifconfig $ip |grep -o -e 'Mask:[^ ]*' | grep -o -e '[^:]*$'"` 
#this check if any ip assigned
if [ -x $INET ];
then
#if no ip we will get no ip address set
INET="no ip address set"
fi 
#we check if we get mask 
if [ -x $MASK ]; 
then 
MASK="no mask address set"
fi 
#and we put result to result file.
echo "$ip : $INET : $MASK" >> $result 
done 
#this print empty line to result file 
echo “” >> $result 
done
