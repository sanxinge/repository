#! /bin/bash
#
#
#
######################################################
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:.
#判断是否是root用户
if test "`whoami`" == "root";then
#只有输入1和2是才能进行下一步，否则一直循环重复提示
while [ "$num" != "1" "$num" != "2" -a "$num" != "\r" -a "$num" != "\n" ] 
do
    read -p "请输入您的选择 1.adduser 2.deluser [1]:" num
done
    case $num in
	"1")
            u=1
	    until [ "$u" -gt 10 ]
	    do
		useradd -M  user$u
		echo user$u:123456 | chpasswd 
		let "u++"
	    done;;
	
	"2")
	    u=1
	    until [ "$u" -gt 10 ]
	    do
		userdel user$u
		let "u++"
	    done;;
    esac
else
	echo '您没有权限执行'
fi

