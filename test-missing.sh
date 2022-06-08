#!/usr/bin/env bash
#
# script to test for missing country/state files
#
for line in `cat dcw-countries.txt | sed '1,$ s/[[:space:]]/_/g'`
do
   file=`echo $line | sed '1,$ s/_/ /g' | awk '{print "orig/"$1"/"$2".txt"}'`
   if [ ! -f $file ]
   then
      echo "Missing $file"
   fi
done
#
for line in `cat dcw-states.txt | sed '1,$ s/[[:space:]]/_/g'`
do

   country=`echo $line | sed '1,$ s/_/ /g' | awk '{print $1}'`
   continent=`grep "[[:space:]]$country[[:space:]]" dcw-countries.txt | awk '{print $1}'`
   file=`echo $line | sed '1,$ s/_/ /g' | awk -v cont=$continent '{print "orig/"cont"/"$1"/"$2".txt"}'`
   if [ ! -f $file ]
   then
      echo "Missing $file"
   fi
done
exit
