#!/bin/bash

FISH=/gata/joiglu/cophyhopa/data/Fish_clean2.tsv
USED=/gata/mar/cophyhopa/results/2022-04-22/assem2_clust_0.93/s3_cluster_stats.txt

if [ ! -e popmap.txt ]; then
   if [ ! -e filter.txt ]; then
      cut -d " " -f 1 $USED | tail -n +2 > filter.txt
   fi
   cut -f 1,2,16,17 $FISH | \
   gawk '(NR > 1){
      gsub(/C\./, "", $0)
      gsub(/ü/, "u", $2)
      if ($3 == $4) {
         S = $3
      } else {
         S = $3 "/" $4
      }
      print $1 "\t" substr($2, 1, 3) "_" S
   }' | \
   sed 's./NA..' > z1.txt
   grep -f filter.txt z1.txt > z2.txt

   cut -f 2 z2.txt | cut -d "_" -f 2 | sort | uniq > species.txt

   gawk '(FILENAME == "species.txt"){
      CODE[$1] = NR
   }(FILENAME == "z2.txt"){
      split($2, A, "_")
      print $1 "\t" sprintf("%s%02i", toupper(A[1]), CODE[A[2]])
      POPS[sprintf("%s%02i", toupper(A[1]), CODE[A[2]])] = 1
   }END{
      LINIA = "# "
      for (p in POPS) {
         LINIA = LINIA p ":0 "
      }
      print LINIA
   }' species.txt z2.txt > popmap.txt
   rm z1.txt
fi

if [ ! -e species_numerades.txt ]; then
   nl species.txt > species_numerades.txt
fi
