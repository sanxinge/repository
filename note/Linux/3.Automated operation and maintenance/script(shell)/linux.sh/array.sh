#! /bin/bash
array=(1 2 3 4 5 6 )
for num in ${array[*]}
do
	echo $num
done
echo -----------------------------------
read -p "请输入一个整数：" num
for ((x=1;x<=num;x++))
do
	for ((y=1;y<=x;y++)) 
	do
		echo -n " *"
	done
	echo ""
done
echo ------------------------------------
for ((x=0;x<num;x++))
do
	for ((c=num;c>x;c--))
	do
		echo -n " "
	done
	for ((y=0;y<x+1;y++)) 
	do
		echo -n " *"
	done
	echo ""
done
echo ------------------------------------
