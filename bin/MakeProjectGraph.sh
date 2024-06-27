#!/bin/bash

CURRENT=$(pwd)
RESULTS=$(find . -type d -name results)

for folder in $(ls -1 $RESULTS); do
   if [ -d $RESULTS/$folder ]; then
      for rmd in $(find $RESULTS/$folder -name '*.Rmd'); do
         for ref in $(grep -o -P "\/[0-9]{4}-[0-9]{2}-[0-9]{2}" $rmd); do
            echo -e $folder "\t" $ref | sed 's|/||'
         done
      done
      for executable in $(find $RESULTS/$folder -type f -perm -o=x); do
         for ref in $(grep -o -P "\/[0-9]{4}-[0-9]{2}-[0-9]{2}" $executable); do
            echo -e $folder "\t" $ref | sed 's|/||'
         done
      done
   fi
done
