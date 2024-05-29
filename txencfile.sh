#!/bin/bash
F1=$1
if [ "$F1" = "" ]; then
	echo Encrypt a file
	echo "Usage: txencfile.sh </path/to/filename> [options]"
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

source etc/txgetopt.sh

FN=$(basename -- "$F1")
EX="${FN##*.}"
FP="${F1%%.*}"
FN="${FN%.*}"
echo out: $FP.enc
PASS=
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
if [ -n "${django+x}" ]; then
	PASS=" -k $DJANGO_CONFIG"
	echo Encrypting with DJANGO_CONFIG
elif [ -n "${import+x}" ]; then
	PASS=" -k $IMPORT_CONFIG"
	echo Encrypting with IMPORT_CONFIG
elif [ -n "${apitoken+x}" ]; then
	PASS=" -k $api_token"
	echo Encrypting with api_token
elif [ -n "${reqpass+x}" ]; then
	PASS=" -k $requirepass"
	echo Encrypting with requirepass	
else
	PASS=" -k $api_token"
	echo Encrypting with api_token
fi
echo "REMARK: Using passwds stored in .bottles"
openssl aes-256-cbc -a -salt -in $F1 -out $FP.enc $PASS -pbkdf2
if [ $? -eq 0 ]; then
	echo Written $FP.enc
else
	echo Error: enc operation failed.
fi

