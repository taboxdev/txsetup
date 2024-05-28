#!/bin/bash
# getopt-simple.sh
# Author: Chris Morgan
# Used in the ABS Guide with permission.

ZDEBUG=0
getopt_simple()
{
    if [ $ZDEBUG -gt 0 ]; then
        echo "getopt_simple()"
        echo "Parameters are '$*'"
    fi
    until [ -z "$1" ]
    do
      if [ $ZDEBUG -gt 0 ]; then
         echo "Processing parameter of: '$1'"
      fi
      #echo ${1:0:1} ${1:1:1}
      if [ ${1:0:1} = '-' ] && [ ${1:1:1} != '-' ]
      then
          tmp=${1:1}               # Strip off leading '/' . . .
          parameter=${tmp%%=*}     # Extract name.
          value=${tmp##*=}         # Extract value.
          if [ $ZDEBUG -gt 0 ]; then
             echo "Parameter: '$parameter', value: '$value'"
          fi
          eval $parameter=$value
      fi
      shift
    done
}

# Pass all options to getopt_simple().
getopt_simple $*


#exit 0  # See also, UseGetOpt.sh, a modified versio of this script.

 
