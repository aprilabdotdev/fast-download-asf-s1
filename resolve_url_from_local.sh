#! /bin/bash

rm -rf resolved_url
total_line=$(cat $1 | grep https | wc -l)
((i=1))
while read LINE; do
    printf "\nresolving url (%s/%s)...\n" $i $total_line
    filename=$(basename $LINE)
    ((i=i+1))
    wget  --user yuxiao --ask-password $LINE -bc  # do the actual download
    sleep 5  # wait 15 seconds (so that the download actually starts)
    while [ ! -f "$filename" ]; do
        sleep 5  # check every 5 seconds
        echo "wait another 5 seconds for download to start..."
    done
    pkill -f 'wget'  # kill the current download process
    cat wget-log | grep Location | grep cloudfront | sed -E 's/Location: (.*) \[following\]/\1/' | tee -a resolved_url
    rm -rf wget-log
    echo "Current ongoing wget process terminated."
done < $1  # $1 is the filename
rm -rf S1*.zip
echo "leftovers cleanup complete."
printf "\n"
echo "Resolving url completed. final url are saved in resolved_url."
