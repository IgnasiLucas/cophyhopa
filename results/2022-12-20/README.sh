#!/bin/bash
#
#				2022-12-20
#				==========
#

FISHDATA=../../data/Fish_clean2.tsv
DEPTHDIR=../2022-12-16

# The goal in this folder is to generate lists of loci, in BED format,
# that are covered in all individuals of each species (<species_name>/common.loci),
# and among all individuals in all species (./common.loci). I use "bedtools intersect"
# to extract common loci from the individual lists of loci with coverage of at least
# 6 reads, in 2022-12-16.

if [ ! -e sample_lake_sp.txt ]; then
   if [ ! -e samples.txt ]; then
      # This is the list of samples for which we have a .bam file in 2022-12-16,
      # from where low-coverage samples (../2022-05-04/TheWorst.txt) have already
      # been removed:
      find ../2022-12-16 -name '*.bam' -exec basename -s .bam '{}' \; > samples.txt
   fi
   # I take the species name from ../../data/Fish_clean2.tsv,
   # but substituting "L", "D" or "S" for a combination of the
   # three first letters of the lake's name and the letter that
   # indicates the ecomorph. In ambiguous assignments the "/" is
   # substituted for "-", like in "C.alpinus-C.stenimanni".
   grep -F -f samples.txt $FISHDATA | cut -f 1,2,19 | \
   gawk '($3 ~ /^[DLP]$/){
      $3 = substr($2, 1, 3) $3
   }{
      gsub(/\//, "-", $3)
      print $1 "\t" $2 "\t" $3
   }' > sample_lake_sp.txt
fi

if [ ! -e species.txt ]; then
   cut -f 3 sample_lake_sp.txt | sort | uniq > species.txt
fi

for sp in $(cat species.txt); do
   if [ ! -d $sp ]; then mkdir $sp; fi
   if [ ! -d $sp/species.txt ]; then
      gawk -v SP=$sp '($3 == SP){print $1}' sample_lake_sp.txt > $sp/samples.txt
   fi
   if [ ! -e $sp/common.loci ]; then
      for sample in $(cat $sp/samples.txt); do
         if [ ! -e $sp/common.loci ]; then cut -f 1,2,3 $DEPTHDIR/$sp/$sample.depth > $sp/common.loci; fi
         bedtools intersect -a $sp/common.loci -b $DEPTHDIR/$sp/$sample.depth > $sp/z.loci
         mv $sp/z.loci $sp/common.loci
      done
   fi
done

if [ ! -e common.loci ]; then
   for sp in $(cat species.txt); do
      if [ ! -e common.loci ]; then cp $sp/common.loci common.loci; fi
      bedtools intersect -a common.loci -b $sp/common.loci > z.loci
      mv z.loci common.loci
   done
fi

# The file "common.loci" includes the 21477 loci covered by at least 6 reads
# in every sample. Let's see what is the number of loci shared by pairs of
# species:

if [ ! -e sharedLoci.txt ]; then
   echo -e "Species1\tNumLoci1\tSpecies2\tNumLoci2\tShared" > sharedLoci.txt
   SPECIES=(C.acrinasus C.albellus C.alpinus C.alpinus-C.steinmanni C.brienzii
            C.brienzii-C.fatioi C.confusus C.duplex C.fatioi C.fatioi-C.albellus
            C.heglingus C.profundus C.steinmanni C.zuerichensis LanD LanL LanP SuoL SuoP)
   for i in $(seq 0 17); do
      for j in $(seq $(( i + 1 )) 18); do
         N1=$(cat ${SPECIES[$i]}/common.loci | wc -l)
         N2=$(cat ${SPECIES[$j]}/common.loci | wc -l)
         SHARED=$(bedtools intersect -a ${SPECIES[$i]}/common.loci -b ${SPECIES[$j]}/common.loci | wc -l)
         echo -e "${SPECIES[$i]}\t${N1}\t${SPECIES[$j]}\t${N2}\t${SHARED}" >> sharedLoci.txt
      done
   done
fi

# The proportion of shared in pairs of species is high. Now, I need a list of all
# loci to genotype in the outgroup species. That's not the common loci, but the
# sum of all loci. I can get that with "bedtools merge".

# First, by species.

for sp in $(cat species.txt); do
   if [ ! -e $sp/merged.loci ]; then
      cat $DEPTHDIR/$sp/*.loci | \
      sort -k 1d,1 -k 2n,2 | \
      cut -f 1,2,3 | \
      uniq | \
      bedtools merge -i - > $sp/merged.loci
   fi
done

if [ ! -e merged.loci ]; then
   find . -mindepth 2 -name merged.loci | \
   xargs cat | \
   sort -k 1d,1 -k 2n,2 | \
   cut -f 1,2,3 | \
   uniq | \
   bedtools merge -i - > merged.loci
fi
