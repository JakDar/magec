#!/bin/bash

start=$(date -u +"%H:%M:%S")
echo "$start starting 1M batch"

error_file=./error.log
empty_file=./empty.log
while read xml_file ;do
    #    new_file="out/a$(echo $xml_file | awk -F'/' '{gsub($1"/","-");gsub("/",".");print $ala}.txt')"
    new_file="${xml_file//\//-}.txt"
    new_file="out/${new_file#*-}"
#    echo $new_file

    
    awk 'BEGIN {p=0}; /\<body\>/{p=1}; /<\/text>/{p=0}; p' < $xml_file | xmlstarlet sel -t -m '//u'  -v . -n -t -m '//p' -v . -n > $new_file
    
    # if [ "$(stat -c "%s" $new_file)" = 0 ];then
    #     echo $new_file >> $empty_file
    #     echo $new_file
    # fi
done

echo "$(date -u +"%H:%M:%S")$ finished 1M batch started at $start"
