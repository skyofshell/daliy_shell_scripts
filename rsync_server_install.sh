#!/bin/bash
#########################################################################
# File Name: rsync_server_install.sh
# Author: shenkai
# mail:skyofshell@163.com
# Created Time:Wed 03 May 2017 08:32:56 AM CST
# Description:install and configure rsync server shell scripts
#########################################################################
##需要交互的是数据备份的位置和模块名称
##varibles
module_name=
path=
user="rsync_backup"
pass=$(echo $RANDOM|md5sum|cut -c 1-6)
#show start screen function
#print #### function
print_(){

echo -e "#######################################################################################"

}
show_star_screen(){
echo " this scripts can be installing rsync server,please to do configure step by step "
sleep 3
read -p "please input module name:" -t 30 module_name
read -p "please input absolute path:" -t 30 path

}
#if path  correct
check_path(){
if [ -d $path ];then
echo "$path exits,please restart input"
read -p "please input absolute path:" -t 30 path
check_path
fi
}
#check if rsync software exits
check_rsync(){
rpm -qa|grep rsync &>/dev/null
[ $? == 0 ] || echo "rsync is not existing ,please install " 

}
configrue_rsync(){
cat >/etc/rsyncd.conf<<EOF
#rsync_config file star
#global configure
uid = rsync
gid = rsync
use chroot = no
max connections = 200
timeout = 300
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
#module configure
[$module_name]
path = $path
ignore errors
read only = false
list = false
hosts allow = 172.16.1.0/24
hosts deny = 0.0.0.0/32
auth users =$user
secrets file = /etc/rsync.password
#rsync_config file end
EOF
creat_user
creat_module_path
creat_rsync_pass
}
##create process user
creat_user(){
id rsync &>/dev/null
[ $? == 1 ] && useradd -s /sbin/nologin -M rsync
}
#creat moudirectiry
creat_module_path(){

mkdir $path
chown -R rsync.rsync $path

}
##creat password file
creat_rsync_pass(){
echo "$user:$pass">/etc/rsync.password
chmod 600 /etc/rsync.password
}
##start rsync daemon process
start_rsync_daemon(){
rsync --daemon
}
##check if rsync configure succeed
if_configure_succe(){
print_
echo -e " this is rsyncd.conf\n"
cat /etc/rsyncd.conf
sleep 10
print_
echo -e " check if rsync user exists\n"
id rsync
sleep 5
print_
echo -e "check ownner and group of module path \n"
ls -dl $path
sleep 5
print_
echo -e "check permission bit  of password file \n"
ls -l /etc/rsync.password 
sleep 5
print_
echo " check daemon of rsync "
ps -ef |grep "rsync --daemon"
sleep 5
}
##show end screen
show_end_screen(){
print_
echo "module name is : $module_name"
echo "user is : $user"
echo "password is : $pass"
echo "module path is : $path"
print_
echo "           success         "
print_
}

#mian function
main(){
show_star_screen
check_path
check_rsync
configrue_rsync
start_rsync_daemon
if_configure_succe
show_end_screen
}
main
