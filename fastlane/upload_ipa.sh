#!/bin/bash -e

param_num=$#
echo "param num = ${param_num}"
if [ ${param_num} -lt 2 ]; then
   echo "param error"
   exit 1
fi

USER='hlw'
PASSWD='123456'
FILE=$1
HOST=$2
echo "FILENAMR=${FILE}"
echo "HOST=${HOST}"

expect -c "
set timeout 600; ##设置拷贝的时间，根据目录大小决定，我这里是1200秒。
spawn /usr/bin/scp ${FILE} ${USER}@${HOST}:/Applications/XAMPP/xamppfiles/htdocs/BeeHome_IOS/Environment/
expect {
\"*yes/no*\" {send \"yes\r\"; exp_continue}
\"*Password*\" {send \"123456\r\";} ##远程IP的密码。
}
expect eof;"

