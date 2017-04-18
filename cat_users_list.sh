###查找系统中的普通用户，并且将别名us加入到系统变量中
/bin/touch /usr/user_list.sh
/bin/echo 'egrep "[5,6,7,8,9][0-9]{2,}|[1-9][0-9]{3,}" /etc/passwd |cut -d ":" -f1' > /usr/user_list.sh
/bin/echo "alias us='/bin/bash /usr/user_list.sh'" >> /etc/profile

