# #! /bin/ls 
#! /bin/bash 
#单行注释
:<<BLOCK
块注释
#! shell 会读取而# 是注释不会读取
BLOCK
echo "Hello Bash shell"
echo $? #退出状态码
exit 23	#自定义突出状态
echo $?

