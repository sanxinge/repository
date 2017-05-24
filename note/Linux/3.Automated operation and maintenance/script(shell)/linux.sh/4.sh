#! /bin/bash
v1=100
func(){
	echo $v1
        local v1=200	#定义局部变量
	echo $v1	#局部变量只能在本函数内调用
}
func
echo $v1
unset v1
echo '已清除变量'
echo "v1=$v1"
