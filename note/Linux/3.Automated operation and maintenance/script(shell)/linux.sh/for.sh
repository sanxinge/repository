#! /bin/bash
for var in 1 2 3 4 5 6 
do
	echo "The number is $var"
done
echo --------------------------------
sum=0;
for var1 in {1..100..2}
do
	let "sum+=var1"
done
echo "The sum is $sum"
echo ---------------------------------
#read -p '请输入一个整数：' num
for  day in mon tue wed thu fri sat sun
do
	echo "$day"
done
echo ---------------------------------
for file in `ls`; #`ls`等同于$(ls)
do
	echo $file
done
echo ----------------------------------
for arg in $@ ; #获取参数个数
do
	echo $arg
done
echo ----------------------------------
sum=0
for ((i=1;i<=100;i=i+2))
do
	let "sum+=i"
done
echo $sum
