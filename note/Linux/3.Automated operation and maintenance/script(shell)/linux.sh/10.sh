#! /bin/bash
var=name
name=john	#一个变量名是一个变量的值
function func()
{
	echo "$1"
}
func "$var"
func ${!var}	#通过间接变量应用来实现函数参数的传递
name=Alice
func "$var"
func "${!var}"

