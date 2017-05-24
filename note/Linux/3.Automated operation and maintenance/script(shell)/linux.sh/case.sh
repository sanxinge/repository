#! /bin/bash
echo 'Hit a key then hit return.'
read keypress
case "$keypress" in
	[[:lower:]])
		echo 'Lowercase letter.';;
	[[:upper:]])
		echo 'Uppercase letter.';;
	[0-9])
		echo 'Digit.';;
	*)
		echo 'Other letter.';;
esac
