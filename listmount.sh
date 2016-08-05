#!/bin/bash

result=$(
    lsblk -n -P -o NAME,RM,FSTYPE,MOUNTPOINT,LABEL |
        while read i; do
            eval "$i"
            device=/dev/"$NAME"
            if [ "$RM" = "1" ] && [  -n "$FSTYPE" ]; then
                if [ -n "$MOUNTPOINT" ]; then
                    printf  "%-10s M %-12s %s\n" "${device}" "$LABEL" "$MOUNTPOINT" 
                else
                    printf  "%-10s U %-12s\n" "${device}" "$LABEL"
                fi
            fi
        done) 

count=$(echo "$result" |wc -l)

result=$(echo "$result" | dmenu -p "select device to mount/unmount" -i -l $count)
      
if [ $? -eq 0 ]; then
    set -- $result
    if [ "$2" = "U" ]; then
        udevil --quiet mount "$1"
    else
        udevil --quiet unmount "$1"
    fi
fi
