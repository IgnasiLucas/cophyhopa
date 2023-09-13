# This script processes the output of "samtools depth *.bam",
# which has 2+n columns: chromosome, position, and depth of coverage
# in each of n samples. This has not been tested very
# thoroughly. If it works as intended, the output summarizes the
# coverage per "locus", understanding by "locus" every
# "contiguous" (with gaps shorter than GAP) stretch of at
# least MINLENGTH bases with a minimum depth of MINCOV.
# GAP = 1 means, strict continuity.

BEGIN{
   #print "chr\tstart\tend\tMeanCov"
   MINCOV = 6
   NUMSITES = 0
   GAP = 1
   MINLENGTH = 60
}{
   NUMCOVERED = 0
   for (i = 3; i <= NF; i++) {
      NUMCOVERED += ($i >= MINCOV)
   }
   if (NUMCOVERED == NF - 2) {
      if (($1 != CHR) || ($2 > LAST + GAP)){
         if (NUMSITES >= MINLENGTH) {
            LINE = CHR "\t" FIRST "\t" LAST
            for (i = 3; i <= NF; i++) {
               MEANCOV = COVSUM[i] / NUMSITES
               LINE = LINE "\t" MEANCOV
            }
            print LINE
         }
         CHR = $1
         FIRST = $2
         NUMSITES = 0
         delete COVSUM
      }
      LAST = $2
      NUMSITES += 1
      for (i = 3; i <= NF; i++) {
         COVSUM[i] += $i
      }
   }
}END{
   if (NUMSITES >=MINLENGTH) {
      LINE = CHR "\t" FIRST "\t" LAST
      for (i = 3; i <= NF; i++) {
         MEANCOV = COVSUM[i] / NUMSITES
         LINE = LINE "\t" MEANCOV
      }
      print LINE
   }
}
