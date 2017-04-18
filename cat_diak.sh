#!/bin/bash
###3中数据的读取方式，从命令行直接传参或者输入变量
##第一种方式，传参
#MAX=$1
#第二种方式，交互式的设置阀值，最好是第一种，但是本脚本为了感受效果，采用的第二种
#第三种，直接设置阀值，这种方式适用于自动化运维
###设置阀值，并检测
read MAX
/bin/df -h |grep '/$'|awk -F "[ %]+" '{print$5}' >/tmp/num
if [ `cat /tmp/num` -gt  $MAX ];then
echo "警告，当前硬盘使用率超过了$MAX%,为:`cat /tmp/num`%"|grep --color=auto '.*'
##while 条件
#do
##函数体
##don
du -sh /* > /tmp/num2 2>&1
echo  "当前较大的文件有"
echo " `cat /tmp/num2 |grep --color=auto '.*G.*' ` "
rm -f /tmp/num >/dev/null 2>&1
else 
echo "当前磁盘使用良好"



fi
