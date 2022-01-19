#!/bin/bash
#
#				2022-01-19
#				==========
#
# To visualize the quality control results from 2021-11-29, I think it would
# be good to make a movie from the png files. I can use the program ffmpeg for
# that. It seems easy. Let's try.

RUN=( zeroNotUsed ../2021-11-29/reports1 ../2021-11-29/reports2 )

for i in per_base_quality \
         per_tile_quality \
         per_sequence_quality \
         per_base_sequence_content \
         per_sequence_gc_content; do
   for run in 1 2; do
      for read in R1 R2; do
         if [ ! -e $i.run$run.$read.mp4 ]; then
            if [ ! -d z ]; then mkdir z; fi
            n=1
            for file in $(ls -1 ${RUN[$run]}/*${read}_001_fastqc.zip | grep -v HOP); do
               sample=$(echo $file | cut -d "_" -f 1)
               folder=$(basename -s .zip $file)
               unzip -p $file $folder/Images/$i.png > $(printf "z/img%03i.png" $n)
               n=$(( n + 1 ))
            done
            ffmpeg -y -framerate 18 -i z/img%03d.png $i.run$run.$read.mp4
            rm -r z
         fi
      done
   done
done
