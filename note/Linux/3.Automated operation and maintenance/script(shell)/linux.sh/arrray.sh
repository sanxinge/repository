#! /bin/bash
array[1]=one
array[3]=three
echo "${array[@]}"
echo --------------------------------------
array=(2 3 4 5 6 7 8 9)
echo "数组第一个元素的字符长度${#array[0]}"
echo "${array[@]}"
echo "${#array[@]}"
echo --------------------------------------
declare -A test1	#-A关联数组
test1=([flower]=rose [fruit]=apple)
echo "the flower is ${test1[flower]}"
echo "the fruit is ${test1[fruit]}"
echo "the size of the tset array is ${#test1[@]}"
echo -------------------------------------
test2="123"	#普通变量做数组来处理
echo "${test2[0]}"	
echo "${test2[@]}"	#输出所有元素的值
echo "${test2[*]}"	#输出所有元素的值
echo -------------------------------------
students=(John Rose Tom Tim)
echo "The old students are:${students[*]}"
students[0]=Susan
students[3]=Jack
echo "The new students are:${students[*]}"
declare -A grades
grades=([john]=90 [rose]=87 [tim]=78 [tom]=85 [jack]=78)
echo "The old grades are:${grades[*]}"
grades[tim]=84
echo "The old grades are:${grades[*]}"
echo ------------------------------------
a=(a b c def)
echo "${a[@]}"
a=(h i j k l m n)
echo "${a[@]}"
a=(z y)
echo "${a[@]}"
echo -------------------------------------
test3=(1 2)
echo "${test3[@]}"
test3[2]=3
test3[3]=4
echo "${test3[@]}"
echo ---------------------------------------
n=0
for i in a b c d e f g h j k;do
	test4[$n]=$i
	let "n++"
done
echo "${test4[3]}"
echo "${test4[@]}"
echo ----------------------------------------
linux=(Debian Redhat Ubuntu Suse)
echo "第四个元素是${linux[3]}"
echo "第四个元素的字符个数:${#linux[3]}"
echo "第一个元素是${linux}"
echo "第一个元素的字符个数:${#linux}"
echo -----------------------------------------
#数组遍历
test5=(a b c d e f g)
len="${#test5[@]}"
for ((i=0;i<len;i++));do
	echo "${test5[*]}"
done	
echo ----------------------------
#切片
#语法 ${array[@|*]:start:length}
linux=("Debian" "Redhat" "Ubuntu" "Suse" "Fedora" "UTS" "CentOS")
test6=(${linux[@]:2:4})
echo $test6
for ((i=0;i<$test6;i++));do
	echo "${test6[$i]}"
done
echo ---------------------------

