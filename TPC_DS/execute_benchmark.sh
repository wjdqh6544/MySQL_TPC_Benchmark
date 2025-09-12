#!/bin/bash

user='root'
pw='root'
DBName='tpcds'
fileList=./sample_queries/*.sql
resPath=./result/
resName=elapsed_time_$(date +%Y%m%d_%H%M%S).out

if [[ "$#" -ne 1 || ! "$1" =~ ^[0-9]+$ ]]; then
  echo
  echo "Usage: $0 <The number of Iterations>"
  echo
  exit 1
fi

if [ ! -d './result' ]; then
    mkdir result
fi

echo

for ((repeatCnt=1; repeatCnt <= $1; repeatCnt++))
do

    if [ ! -d './result/repeat_$repeatCnt' ]; then
        mkdir result/repeat_$repeatCnt
    fi

    for file in $fileList
    do
        name=`basename $file`    
        name=${name%.*}
        fullPath=$resPath'repeat'$repeatCnt'_'$resName

        echo -n 'Repeat: '$repeatCnt'/'$1', Execution: '$file
        start_time=$(date +%s%N)
        MYSQL_PWD="$pw" mysql -u$user -D$DBName < $file > ./result/repeat_$repeatCnt/$name.out
        end_time=$(date +%s%N)
        elapsed=$((end_time-start_time))

        echo ' (Elapsed: '$elapsed' NanoSec.)'
        echo
        echo 'Repeat: '$repeatCnt'/'$1', Execution Name: '$file' (Elapsed: '$elapsed' Sec.)' >> $fullPath
    done
done
