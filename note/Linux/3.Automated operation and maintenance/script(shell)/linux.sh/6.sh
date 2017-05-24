#! /bin/bash
file=/bin/bash
if [ -f $file ]；then
	then echo '/bin/bash is file'
fi
echo -------------------------------------------------------------------
test "$(whoami)"!="root" && (echo 'you are using a non-privileged')	# &&可以代替if语句
test "`who`"!="dream" && (echo 'you are using is dram');
echo -------------------------------------------------------------------
echo '请输入一个数字:'
read num
if [ $num -gt 10 ];then
	echo 'The number is greater than 10.'
else
	echo 'The number is qeual to or less than 10.'
fi
echo -------------------------------------------------------------------
exit 222
