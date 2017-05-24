#! /bin/bash
function length()
{
	#接受第一个参数
	str=$1
	result=0
	if [ "$str" != "" ];then
		#计算字符串长度
		result=${#str}
	fi
	#将长度值写入标准输出
	echo "$result"
}
#调用length function
len=$(length "$1")
echo "the string is length is $len"
