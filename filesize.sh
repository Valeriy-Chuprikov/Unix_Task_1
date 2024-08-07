#!/bin/bash

s_small=0
s_big=0
sum=0
sep=""
error_flag=0
double_dash=0

for arg in "$@"
do
	if [[ "${arg:0:1}" = "-" ]]
	then
  		if [[ "$arg" == "-s" ]]
  		then
			s_small=1

  		elif [[ "$arg" == "-S" ]]
  		then
			s_big=1

  		elif [[ "$arg" == "--help" ]]
  		then
			echo "this is a help: "
  			echo "Give the size of given files in paramters"
  			echo "-s :to add the total at the end"
  			echo "-S : to show that the total size of the files given in parameters"
  			echo "--help : for help"
  			echo "--usage to show the usage "
  			exit 0

  		elif [[ "$arg" == "--usage" ]]
  		then 
			echo "this is the usage";
			exit 0

  		elif [[ "$arg" == "--" ]]
  		then 
			sep="--"
			break

  		else
  			echo "ERROR" >&2
   			exit 2

  		fi
	fi
done

for arg in "$@"
do  
	if [[ "$arg" == "--" ]]
	then 
		double_dash=1
		continue
	fi

	if [[ $double_dash == 0 && ( "$arg" == "-s" || "$arg" == "-S" ) ]]
  	then continue
	fi

	if [ -e "$arg" ]
        then
		
    		if ( stat  $sep "$arg" > /dev/null 2>&1 )
    		then
      			size=$(stat --format "%s" $sep "$arg")
      			(( $s_big == 0 )) && echo $size "$arg"
      			sum=$(($sum+$size))
    		else
      			(( $s_big == 0 )) && echo "ERROR"
      			error_flag=1
    		fi

  	else 
    		echo "ERROR" >&2
    		error_flag=1
  	fi
done

if (( $s_small==1 || $s_big==1 ))
then 
	  echo total $sum
fi

[[ $error_flag ]] && exit 1 || exit 0

