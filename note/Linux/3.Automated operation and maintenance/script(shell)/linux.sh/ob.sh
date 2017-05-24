#! /bin/bash
while [ "$jinzhi" != "1" -a "$jinzhi" != "2" ]
do
	read -p "[1]十进制转二进制 [2]二进制转十进制：" jinzhi
case $jinzhi in
	[1])
		while [ "$num" != "q" ];do
			read -p "请输入一个十进制数：" num
			echo "obase=2;ibase=10;$num"|bc
		done;;
	"2")
		while [ "$num" != "q" ];do
			read -p "请输入一个二进制数：" num
			echo "obase=10;ibase=2;$num"|bc
		done;;
esac
done
