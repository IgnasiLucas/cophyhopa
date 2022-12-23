#!/bin/bash

for sp in `cat alpine_species.txt`; do 
   cut -d " " -f 1,3 ~/cophyhopa/data/popmap.txt | grep $sp |\
   grep -v / | tr -d '"' > ${sp}.txt
done

for sp in `cat arctic_species.txt`; do 
  for lake in LAN SUO; do 
    cut -d " " -f 1,3 ~/cophyhopa/data/popmap.txt | grep $lake |\
    awk -v LAKE="${lake}" '{ print $1, LAKE "_" $2; }' |\
    tr -d '"' |\
    grep _${sp} > ${lake}_${sp}.txt
  done 
done

rm SUO_D.txt ## no samples

## creating the txt file with the 5 options for vcftools 
ls ./ | grep -E "LAN|SUO" | \
tr -d ".txt" | \
tr "\n" ' ' > artcic_species2.txt
#sed -i -e '$a\' arctic_species2.txt #add a new empty line at the end of the file 