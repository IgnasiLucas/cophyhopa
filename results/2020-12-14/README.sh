#!/bin/bash


for i in 1 31 61 91 121 151 181 211 241; do
   if [ ! -e digestions$i.txt ]; then
      R --no-save -q < digestions.R --args $i $(( i + 29 )) 1> run$i.log 2> run$i.err &
   fi
done

R --no-save -q < digestions.R --args 271 299 1> run271.log 2> run271.err &

wait




