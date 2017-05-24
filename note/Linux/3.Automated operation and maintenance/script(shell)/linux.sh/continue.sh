#! /bin/bash
#输出1到100之间的偶数
for num in {1..100}
do
	#判断是否为奇数
	if [ "$[num%2]" -eq 1 ];then
		continue
	fi
	echo -n "$num,"
done
echo ----------------------------------------------------
for i in a b c d
do
	echo -n "$i："
	for j in `seq 10`
	do
		for z in y u i o
		do
			if [ "$z" = u ];then
			      	continue 2 #由内而外忽略两层for循环中continue后的语句
			fi
			echo -n "$z"
		done
		echo -n "$j"
	done
	echo
done
