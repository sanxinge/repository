#! /bin/bash
var=120
function test1()
{
	local var1=234
	echo "var=$var"
	echo "var1=$var1"
}
	test1
	echo "var=$var"
	echo "var1=$var1"
