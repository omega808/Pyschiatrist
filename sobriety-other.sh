#!/bin/bash 
#Author: New Wavex86 
#Date Created: Thu 13 Aug 2020
#A script written  quickly to test sobirety

#Variable to add daily
DAYS=$( cat sobriety-date.txt | awk ' NR==2 { print $1 }' )

#Get rid of old entry
sed -i 2d sobriety-date.txt

#Add a day 
let DAYS++

echo "$DAYS days clean" >> sobriety-date.txt

exit 0 
