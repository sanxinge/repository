#! /bin/sh
x=123
let "x  = x + 3"
echo "x=$x"
echo 
y=${x/1/abc}
echo "y=$y"
declare -i y
echo "y=$y"
let "y += 1"
echo "y=$y"
z=abc22
echo "z=$z"
m=${z/abc/11}
echo m=$m
let "m += 1"
echo m=$m

n=""
echo "n = $n"
let "n += 1"
echo "n= $n"
echo "p = $p"
let "p += 1"
echo "p = $p"

echo ------------------------------------------
x=6/3
echo "$x"
declare -i x
echo "$x"
x=6/3
echo "$x"
x=hello
echo "$x"
x=3.14
echo "$x"
declare +i x
x=6/3
echo "$x"
x=$[6/3]
echo "$x"
x=$((6/3))
echo "$x"
declare -r x
echo "$x"
x=5
echo "$x"
