#! /bin/bash
####################################
#
#
#if elif 语句
#
###################################
echo '请输入成绩：'
read score
if [ -z $score ];then
	echo '输入成绩不能为空，请重新输入：'
	read score
  elif [ $score -lt 0 -o $score -gt 100 ];then
	echo '输入成绩无效，请重新输入：'
	read score
  elif [ $score -ge 90 ];then
	echo 'A'
  elif [ $score -ge 80 ];then
	echo 'B'
  elif [ $score -ge 70 ];then
	echo 'C'
  elif [ $score -ge 60 ];then
	echo 'D'
  else
	echo 'E'
fi

