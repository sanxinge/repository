#! /bin/bash
function hello()
{
	echo "hello work"
}
function date1()
{
	hello
	date1="`date`"
	echo "$date1"
}

date1
