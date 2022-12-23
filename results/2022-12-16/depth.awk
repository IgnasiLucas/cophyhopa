# This script processes the output of "samtools depth input.bam",
# which has three columns: chromosome, position, and depth of coverage.
# Additional columns are ignored. This has not been tested very
# thoroughly. If it works as intended, the output summarizes the
# coverage per "locus", understanding by "locus" every
# stretch with at least a minimum coverage of MINCOV.
BEGIN{
   print "chr\tstart\tend\tMeanCov"
   MINCOV = 6
   NUMSITES = 0
   COVSUM = 0
   GAP = 450
   MINLENGTH = 60
}($3 >= MINCOV){
   if (($1 != CHR) || ($2 > LAST + GAP)){
      if (NUMSITES >= MINLENGTH) {
         MEANCOV = COVSUM / NUMSITES
         print CHR "\t" FIRST "\t" LAST "\t" MEANCOV
      }
      CHR = $1
      FIRST = $2
      NUMSITES = 0
      COVSUM = 0
   }
   LAST = $2
   NUMSITES += 1
   COVSUM += $3
}END{
   if (NUMSITES > 0) {
      MEANCOV = COVSUM / NUMSITES
   } else {
      MEANCOV = "NA"
   }
   print CHR "\t" FIRST "\t" LAST "\t" MEANCOV
}
