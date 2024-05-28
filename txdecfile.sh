#!/bin/bash
F1=$1
if [ "$F1" = "" ]; then
	echo Decrypt a file with extension \'.enc\'
	echo "Usage: txdecfile.sh </path/to/filename.enc>"
	exit
fi
if [ ! -f $F1 ]; then
	echo
	echo Error: file \'$F1\' not found
	exit
fi

if [ ! -d ./.git ]; then
	echo Error: Run this script at the same level as .git folder 
	exit 1
fi

if ! command -v openssl &> /dev/null
then
    echo "'openssl' could not be found"
    exit
fi
PASS=
FN=$(basename -- "$F1")
EX="${FN##*.}"
FP="${F1%%.*}"
FN="${FN%.*}"
echo out: $FP.dec
if [ -f etc/.bottles ]; then
	source etc/.bottles
elif [ -f ./.bottles ]; then
	source ./.bottles
else
	echo Warning: etc/.bottles not found.
	echo Creating it from .bottles.template
	if [ -f etc/.bottles.template ]; then
		cp -puv etc/.bottles.template etc/.bottles
		BOTTLES=etc/.bottles
	elif [ -f ./.bottles.template ]; then
		cp -puv ./.bottles.template ./.bottles
		BOTTLES=./.bottles
	else
		echo Error: .bottles.template not found. Your repo might be corrupt.
	fi
	echo Edit $BOTTLES and populate
	exit 1
fi
if [ "$FN" = "config" ]; then
	PASS=" -k $DJANGO_CONFIG"
	echo Decrypting DJANGO_CONFIG
else
	PASS=" -k $IMPORT_CONFIG"
	echo Decrypting IMPORT_CONFIG
fi
if [ "$EX" = "enc" ]; then
	echo "REMARK: Using passwds stored in .bottles"
	openssl aes-256-cbc -d -a -in $F1 -out $FP.dec $PASS -pbkdf2
	if [ $? -eq 0 ]; then
		echo Written $FP.dec, backing up and writing new JSON...
		cp -v $FP.json $FP.json.bak
		mv -v $FP.dec $FP.json
	else
		echo Error: dec operation failed.
	fi	
else
	echo Error: extension \'.enc\' was expected, found \'.$EX\'
fi
