#! /bin/bash

for ((x=1;x<10;x++))
do
	for ((y=1;y<=x;y++))
	do
		let "square=x*y"
		echo -n "$x*$y=$square	"
	done
	echo ""
	if [ $x -eq 5 ];then
		break
	fi
done
echo -------------------------------
x=1;y=1;
