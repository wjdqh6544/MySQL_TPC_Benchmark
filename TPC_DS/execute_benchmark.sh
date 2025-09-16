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
        start_time_sec=$(date +%s)
        start_time_nsec=$(date +%N)
        start_time=$((10#$start_time_sec*1000000000 + 10#$start_time_nsec))
        MYSQL_PWD="$pw" mysql -u$user -D$DBName < $file > ./result/repeat_$repeatCnt/$name.out
        end_time_sec=$(date +%s)
        end_time_nsec=$(date +%N)
        end_time=$((10#$end_time_sec*1000000000 + 10#$end_time_nsec))
        elapsed=$((10#$end_time - 10#$start_time))

        echo ' (Elapsed: '$elapsed' NanoSec.)'
        echo
        echo "Repeat: $repeatCnt/$1, Execution Name: $file (Elapsed: $elapsed NanoSec.)" >> $fullPath
    done
done
