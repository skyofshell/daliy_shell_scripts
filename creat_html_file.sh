#!/bin/bash
#########################################################################
# File Name: creat_html_file.sh
# Author: shenkai
# mail:skyofshell@163.com
# Created Time:Sat 11 Mar 2017 08:59:45 PM CST
# Description:创建10个html文件，并且名字中有10位随机小写字母
#########################################################################
letter_random (){ ###创建随机数的函数
rm -f /tmp/aa
letter_all=()
str=`echo {a..z}`
letter_all=($str)
for ((i=0;i<10;i++))
do
ran1=$[$RANDOM%26]
echo -n ${letter_all[$ran1]} >>/tmp/aa ##本来想用文件描述符来完成这一步，可惜没完成
done
}
####创建文件的主脚本
for num in $(seq 10)
do
letter_random
ran=`cat /tmp/aa`
touch ${ran}_oldboy.html >/dev/null 2>&1
done

