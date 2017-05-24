#! /bin/bash
func()
{
	#逐个接收选项及其参数
	while getopts "a:b:c" arg;do
		case "$arg" in
			a)	#将a参数的值存到$OPTARG变量并输出
				echo " $OPTARG";;
			b)
				echo " $OPTARG";;
			c)	#getopts后的参数没有":"的不能提供参数值
				echo " $OPTARG";;
			?)
				echo "unkown argument."
				exit 1;;
		esac
	done
}
func -a Hello! -b 你好！ -c 123
