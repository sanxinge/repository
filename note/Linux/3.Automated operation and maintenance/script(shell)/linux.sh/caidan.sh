#! /bin/bash
while [ "$input" != 1 -a "$input" != 2 -a "$input" != 3 -a "$input" != 4 -a "$input" != "q" ]
do
	echo '1:十转二 2:二转十 3:十转八 4:十转十六 q:退出'
	read -p "请输入功能选项：" input
	while [ "$num" != "e" ]
	do
		case $input in
			1)
				read -p "请输入一个十进制数：" num
				echo "obase=2;ibase=10;$num"|bc;;
			2)
				read -p "请输入一个二进制数：" num
				echo "obase=10;ibase=2;$num"|bc;;
			3)
				read -p "请输入一个十进制数：" num
				echo "obase=8;ibase=10;$num"|bc;;
			4)
				read -p "请输入一个十进制数：" num
				echo "obase=16;ibase=10;$num"|bc;;
		esac
	#	test "$num" == "e" && continue
	done
	test "$input" == "q" && break
done
