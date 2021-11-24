#! /bin/bash

total_line=$(cat $1 | grep https | wc -l)
((i=1))
while read LINE; do
    printf "\ndownloading file (%s/%s)...\n" $i $total_line
    fn=$( echo "$LINE" | sed -E 's/.*(S1.*zip).*/\1/g' )
    wget -O $fn $LINE
    ((i=i+1))
done < $1  # $1 is the filename
