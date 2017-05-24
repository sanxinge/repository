#! /bin/bash
function func()
{
	read y
	echo "$y"
	func "$y"
}
func
