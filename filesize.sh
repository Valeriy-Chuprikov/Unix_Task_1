#!/bin/bash

s_small=0
s_big=0
sum=0
sep=""
error_flag=0
double_dash=0

for arg in "$@"
do

	if [[ "${arg:0:1}" == "-" ]]
	then
		case "$arg" in
			-s)
				s_small=1
				continue
				;;
			
			-S)
				s_big=1
				continue
				;;
				
			--help)
				echo "this is a help: "
  				echo "Give the size of given files in paramters"
  				echo "-s :to add the total at the end"
  				echo "-S : to show that the total size of the files given in parameters"
  				echo "--help : for help"
  				echo "--usage : to show the usage"
  				exit 0
				;;

			--usage)
				echo "filesize [--help] [--usage] [-s] [-S] [files...]";
				exit 0
				;;
			--)
				sep="--"
				break
				;;
		
		esac

		echo "Error: wrong option '$arg'"
		exit 2	
	fi
done

for arg in "$@"
do  
	if [[ "$arg" == "--" ]]
	then 
		double_dash=1
		continue
	fi

	if [[ $double_dash -eq 0 && ( "$arg" == "-s" || "$arg" == "-S" ) ]]
  	then continue
	fi

	if [[ -e "$arg" ]]
	then
		size=$(stat --format "%s" $sep "$arg")
		[[ $s_big -eq 0 ]] && echo $size "$arg"
		sum=$(($sum+$size))

	else 
		echo "Error: file '$arg' doesn't exist" >&2
		error_flag=1
	fi

	done

if [[ $s_small -eq 1 || $s_big -eq 1 ]]
then 
	  echo "total $sum"
fi

[[ $error_flag ]] && exit 1 || exit 0

