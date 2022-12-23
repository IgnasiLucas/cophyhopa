#!/bin/bash
#
#				2022-12-14
#				==========
#

if ! $(which ipyrad > /dev/null); then
   echo "you need to conda activate ipyrad"
   exit
fi

if [ ! -e summary.txt ]; then
   if [ ! -d logs ]; then mkdir logs; fi
   if [ ! -e params-run1.txt ]; then
      ipyrad -n run1
      sed -i '/## \[4\]/c ../2021-12-21/run1/*.fastq.gz  ## [4] [sorted_fastq_path]'   params-run1.txt
      sed -i '/## \[5\]/c reference                      ## [5] [assembly_method]'     params-run1.txt
      sed -i '/## \[6\]/c ../../data/reference.fa        ## [6] [reference_sequence]'  params-run1.txt
      sed -i '/## \[7\]/c pairddrad                      ## [7] [datatype]'            params-run1.txt
      sed -i '/## \[8\]/c ,                              ## [8] [restriction_overhang' params-run1.txt
      sed -i '/## \[14\]/c 0.93                           ## [14] [clust_threshold]'   params-run1.txt
      sed -i '/## \[21\]/c 1                              ## [21] [min_samples_locus]' params-run1.txt
      sed -i '/## \[23\]/c 2                              ## [23] [max_Indels_locus]'  params-run1.txt
      # Intended to compare only 3 samples, I let them all be heterozygous:
      sed -i '/## \[24\]/c 3                              ## [24] [max_shared_Hs_locu' params-run1.txt
      sed -i '/## \[27\]/c *                              ## [27] [output_formats]'    params-run1.txt
   fi
   if [ ! -e params-run2.txt ]; then
      cp params-run1.txt params-run2.txt
      sed -i '/## \[0\]/c run2                           ## [0] [assembly_name]'       params-run2.txt
      sed -i '/## \[4\]/c ../2021-12-21/run2/*.fastq.gz  ## [4] [sorted_fastq_path]'   params-run2.txt
   fi
   if [ ! -e run1.json ]; then
      ipyrad -p params-run1.txt -s 1 -c 16 1> logs/run1.log 2> logs/run1.err &
   fi
   if [ ! -e run2.json ]; then
      ipyrad -p params-run2.txt -s 1 -c 16 1> logs/run2.log 2> logs/run2.err &
   fi
   wait
   if [ ! -e params-c93.txt ]; then
      # I merge the two assemblies before branching.
      if [ ! -e params-both.txt ]; then
         ipyrad -m both params-run1.txt params-run2.txt
      fi
      # The branching allows me to select just a few samples:
      #    THUN086 is a C. steinmanni, the same species as the reference genome.
      #    LAN103 and SUO105 belong to the most distant clades from the reference.
      ipyrad -p params-both.txt -b c93 THU086 LAN103 SUO105
   fi
   for i in 81 83 85 87 89 91 93 95 97 99; do
      if [ ! -e params-c$i.txt ]; then
         ipyrad -p params-c93.txt -b c$i
         sed -i "/## \[14\]/c 0.$i         ## [14] [clust_threshold]" params-c$i.txt
      fi
      if $(ipyrad -p params-c$i.txt -r | grep -q 'step 2: None'); then
         ipyrad -p params-c$i.txt -s 234567 -c 4 1> logs/c$i.log 2> logs/c$i.err &
      fi
   done
   wait
   echo -e "clust_threshold\tsample\tclusters_total\tfiltered_by_depth\tfiltered_by_maxH\tfiltered_by_maxAlleles\tfiltered_by_maxN\treads_consens\tnsites\tnhetero\theterozygosity" > summary.txt
   find . -name s5_consens_stats.txt -exec gawk '(NR > 1){split(FILENAME, A, /[\/_]/); print A[2] "\t" $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10}' '{}' \; >> summary.txt
fi

if [ ! -e mappingQuality.txt ]; then
   # Clustering threshold does not affect mapping. I get mapping quality statistics
   # from only one clustering threshold.
   for sample in THU086 SUO105 LAN103; do
      if [ ! -e c93_refmapping/$sample.mapq.txt ]; then
         samtools view c93_refmapping/${sample}-mapped-sorted.bam | \
         gawk '{
            split($1, NAME, /=/)
            MAPQ[$5] += NAME[2] + 0
         }END{
            for (i = 0; i <= 60; i++) print MAPQ[i] + 0
         }' > c93_refmapping/$sample.mapq.txt
      fi
   done
   echo -e "MAPQ\tTHU086\tLAN103\tSUO105" > mappingQuality.txt
   seq 0 60 > zmapq.txt
   paste zmapq.txt \
         c93_refmapping/THU086.mapq.txt \
         c93_refmapping/LAN103.mapq.txt \
         c93_refmapping/SUO105.mapq.txt >> mappingQuality.txt
fi

if [ ! -e report.html ]; then
   if [ -e report.Rmd ]; then
      R -q --no-save -e "rmarkdown::render('report.Rmd', output_file = 'report.html')"
   else
      echo "report.Rmd not found."
      exit
   fi
fi
