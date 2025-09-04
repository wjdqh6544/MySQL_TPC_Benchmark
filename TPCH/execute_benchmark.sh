#!/bin/bash

user='root'
pw='root'
fileList=./sample_queries/*.sql
timeRes=./result/elapsed_time_$(date +%Y%m%d_%H%M%S).out

if [ ! -d './result' ]; then
    mkdir result
fi

if [ ! -f './result/'.$timeRes ]; then
    touch $timeRes
fi

echo
for file in $fileList
do
    name=`basename $file`
    name=${name%.*}
    echo -n 'Execution: '$file
    start_time=$(date +%s)
    mysql -u$user -p$pw < $file > ./result/$name.out 2> /dev/null
    end_time=$(date +%s)
    elapsed=$((end_time-start_time))
    echo ' (Elapsed: '$elapsed' Sec.)'
    echo
    echo 'Execution Name: '$file' (Elapsed: '$elapsed' Sec.)' >> $timeRes
    echo >> $timeRes
done