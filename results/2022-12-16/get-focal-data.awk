# get-focal-data.awk
#
# This script is expected to process a VCF with data from a focal species
# and extract the genotypes in the format required by est-sfs, which is
# a comma-separated count of alleles A, C, G and T, in that order, and with
# all raws summing up to the same number of chromosome copies. Because the
# format does not allow for different positions to be genotyped in a different
# number of individuals, I should decide on the final number and downsample
# sites if necessary.

function SUBSAMPLE(SAMPLE,SIZE,   TOTAL,PROB,i,j,X,L){
   for (i in SAMPLE) TOTAL += SAMPLE[i]
   for (i in SAMPLE) {
      PROB[i] = SAMPLE[i] / TOTAL
      SAMPLE[i] = 0
   }
   for (i = 1; i <= SIZE; i++) {
      X = rand()
      j = 1
      L = PROB[1]
      while (X >= L) {
         j++
         L += PROB[j]
      }
      SAMPLE[j]++
   }
}
BEGIN{
   srand()
   if (N + 0 == 0) N = 20
   TONUM["A"] = 1
   TONUM["C"] = 2
   TONUM["G"] = 3
   TONUM["T"] = 4
}((/^[^#]/) && (/TYPE=snp;/)){
   if (length($4) > 1) next
   COUNT[1] = 0
   COUNT[2] = 0
   COUNT[3] = 0
   COUNT[4] = 0
   REF = $4
   split($5, ALT, /,/)
   ALT[0] = REF
   if (length(ALT[1]) > 1) next
   split($8, INFOS, /;/)
   for (i in INFOS) {
      split(INFOS[i], FIELD, /=/)
      INFOR[FIELD[1]] = FIELD[2]
   }
   if (INFOR["NS"] * 2 < N) next
   if ($5 == ".") {
      COUNT[TONUM[REF]] = N
      print COUNT[1] "," COUNT[2] "," COUNT[3] "," COUNT[4]
   } else {
      for (i = 10; i <= NF; i++) {
         if ($i ~ /^[012]\/[012]/) {
            split($i, Z, /:/)
            split(Z[1], GT, /\//)
            COUNT[TONUM[ALT[GT[1]]]]++
            COUNT[TONUM[ALT[GT[2]]]]++
         }
      }
      if (INFOR["NS"] * 2 > N) SUBSAMPLE(COUNT, N)
      print COUNT[1] "," COUNT[2] "," COUNT[3] "," COUNT[4]
   }
}
