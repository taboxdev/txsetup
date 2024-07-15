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
		cp -pv etc/.bottles.template etc/.bottles
		BOTTLES=etc/.bottles
	elif [ -f ./.bottles.template ]; then
		cp -pv ./.bottles.template ./.bottles
		BOTTLES=./.bottles
	else
		echo Error: .bottles.template not found. Your repo might be corrupt.
	fi
	echo Edit $BOTTLES and populate
	exit 1
fi
if [ -n "${django+x}" ]; then
	PASS=" -k $DJANGO_CONFIG"
	echo Decrypting with DJANGO_CONFIG
elif [ -n "${import+x}" ]; then
	PASS=" -k $IMPORT_CONFIG"
	echo Decrypting with IMPORT_CONFIG
elif [ -n "${apitoken+x}" ]; then
	PASS=" -k $api_token"
	echo Decrypting with api_token
elif [ -n "${reqpass+x}" ]; then
	PASS=" -k $requirepass"
	echo Decrypting with requirepass	
else
	PASS=" -k $api_token"
	echo Decrypting with api_token
fi
if [ "$EX" = "enc" ]; then
	echo "REMARK: Using passwds stored in .bottles"
	# Function to compare versions
	version_ge() { 
		# sort -V sorts versions, and we return true if the first argument is sorted as >= the second argument
		printf '%s\n%s\n' "$1" "$2" | sort -V -C
	}

	# Get the active OpenSSL version
	OPENSSL_VERSION=$(openssl version | awk '{print $2}')

	# Enforce OpenSSL version 3 or higher
	REQUIRED_VERSION="3.0.0"
	if version_ge "$OPENSSL_VERSION" "$REQUIRED_VERSION"; then
		echo "OpenSSL version is $OPENSSL_VERSION, which meets the requirement of $REQUIRED_VERSION or higher."
	else
		echo "Error: OpenSSL version $OPENSSL_VERSION is lower than the required version $REQUIRED_VERSION." >&2
		exit 1
	fi	
	openssl aes-256-cbc -d -a -in $F1 -out $FP.dec $PASS -pbkdf2
	if [ $? -eq 0 ]; then
		echo Written $FP.dec
	else
		echo Error: dec operation failed.
		echo "Make sure you updated 'api_token' in etc/.bottles .."
		echo "Current value: $(cat etc/.bottles | grep api_token)"	
        exit 1	
	fi	
else
	echo Error: extension \'.enc\' was expected, found \'.$EX\'
fi
