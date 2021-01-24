#!/bin/bash
#
#				2020-12-14
#				==========
#
# Originally, I used a list of enzymes that Mar made manually. There was the problem
# of the very many combinations, that took very long to test in in silico digestions.
# It is more pragmatic to just look at the comercial provider and make sure the enzymes
# combined are compatible: same temperature of incubation and same buffer. I saved a
# manual compilation of interesting enzymes in ../../data/enzyme_selection.txt. Beaware
# of possible mistakes in typing.
#
# My strategy is to cut with two relatively rare cutters, in order to spread the length
# distribution long enough to be able to select a wide size range, such as 250-650 bp.
# I believe that targetting a wide range will minimize the proportion of out-of-range
# fragments that stay in the tube. I also think that having too many small fragments
# from frequent cutters could impair the efficiency of ligation, due to a potentially
# too high molarity of non-targeted sticky ends. But I don't have evidence.
#
# The enzyme SbfI is popular for long fish genomes, because its recognition site is 8 bases
# long, and unfrequent enough. It is incompatible with NsiI or PstI, because they generate
# the same overhangs. Enzymes PstI and MfeI have also been tested in the literature. I will
# limit myself to enzymes with High Fidelity activity. The combinations to try are these:
#

if [ ! -e combinacions.txt ]; then
   R --no-save -q < combinations.R
   # I remove incompatible combinations.
   grep -E -v "SbfI-HF_NsiI-HF|SbfI-HF_PstI-HF|NsiI-HF_PstI-HF" combinacions.txt > z1
   mv z1 combinacions.txt
fi

# A first round of in silico digestions is used to determine the distribution of fragment
# lengths. I only save the numbers of fragments of each size, using the function
# tabulate() in R.
if [ ! -d digestions ]; then mkdir digestions; fi
if [ ! -d logs ]; then mkdir logs; fi
COMBONUM=$(cat combinacions.txt | wc -l)
# In silico digestion consumes memory, and I cannot run about 30 digestions at a time.
# Let's try running fewer parallel batches of 4 serial digestions:
for i in $(seq 2 4 $COMBONUM); do
   ( for j in $( seq $i $(( i + 3 )) ); do
      COMB=$(head -n $j combinacions.txt | tail -n 1 | cut -f 1)
      S5P1=$(head -n $j combinacions.txt | tail -n 1 | cut -f 2)
      S3P1=$(head -n $j combinacions.txt | tail -n 1 | cut -f 3)
      S5P2=$(head -n $j combinacions.txt | tail -n 1 | cut -f 4)
      S3P2=$(head -n $j combinacions.txt | tail -n 1 | cut -f 5)
      if [ ! -e $(printf "digestions/%s.txt" $COMB) ] && [ $j -le $COMBONUM ]; then
         printf "###################\n%s\n##################\n" $COMB
         R --no-save -q < digestions.R --args $COMB $S5P1 $S3P1 $S5P2 $S3P2
      fi
   done ) > $(printf "logs/%u.log" $i) 2>&1 &
done
wait
# if ! $(grep -q rror logs/*); then rm -r logs; fi

# I select as candidate combinations those that produce between 50000 and 100000
# fragments in the size range 250-650.
if [ ! -e candidates.txt ]; then
   R --no-save -q < summarize.R
fi

# To make a final decision, I will digest again with only those candidates, this
# time looking at the following properties of the products of in silico digestion:
#
#  - Uniqueness of the first and last 15 bases of all fragments, among them.
#  - Uniqueness of the first and last 25 bases of all fragments, among them.
#  - Uniqueness of the first and last 35 bases of all fragments, among them.
#  - Average percentage of G+C in whole fragments.

if [ ! -e report.txt ]; then
   if [ ! -e candidate_combs.txt ]; then
      cut -f 1 -d " " candidates.txt > candidate_combs.txt
   fi
   if [ ! -e combinacions_optimes.txt ]; then
      grep -f candidate_combs.txt combinacions.txt > combinacions_optimes.txt
      rm candidate_combs.txt
   fi
   CANDINUM=$(cat combinacions_optimes.txt | wc -l)
   for i in $(seq 1 3 $CANDINUM); do
      ( for j in $( seq $i $(( i + 2 )) ); do
           COMB=$(head -n $j combinacions_optimes.txt | tail -n 1 | cut -f 1)
           S5P1=$(head -n $j combinacions_optimes.txt | tail -n 1 | cut -f 2)
           S3P1=$(head -n $j combinacions_optimes.txt | tail -n 1 | cut -f 3)
           S5P2=$(head -n $j combinacions_optimes.txt | tail -n 1 | cut -f 4)
           S3P2=$(head -n $j combinacions_optimes.txt | tail -n 1 | cut -f 5)
           if [ ! -e $(printf "digestions/%s_stats.txt" $COMB) ] && [ $j -le $CANDINUM ]; then
              printf "#####################\n%s\n#####################\n" $COMB
              R --no-save -q < digestions2.R --args $COMB $S5P1 $S3P1 $S5P2 $S3P2
           fi
        done ) > $(printf "logs/%u.2.log" $i) 2>&1 &
   done
   wait
   echo -e "#Combination\tNum.expected\tUnique15\tUnique25\tUnique35\tGC" > report.txt
   for comb in $(cut -f 1 combinacions_optimes.txt); do
      echo $(grep $comb candidates.txt) $(tail -n 1 $(printf "digestions/%s_stats.txt" $comb)) | \
      sed 's/ /\t/g' >> z
   done
   LC_ALL=en_US sort -grk 3,3 z >> report.txt
   rm z
fi

###################
#  CONCLUSIONS
###################
#
#         Combination NumFrag    Uniq15    Uniq25    Uniq35        GC
#     NsiI-HF_SphI-HF   65000 0.7071702 0.8138891 0.8692463 0.4250860
#     PstI-HF_SphI-HF   81931 0.6883681 0.7903729 0.8431177 0.4391602
#     PstI-HF_BmtI-HF   71683 0.6777644 0.7784709 0.8317960 0.4405781
#    BsrGI-HF_SpeI-HF   68886 0.6664525 0.7630172 0.8202638 0.4134567
#     BmtI-HF_Ncol-HF   94940 0.6511150 0.7615023 0.8233931 0.4467778
#    SphI-HF_BsrGI-HF   93160 0.6502411 0.7657341 0.8250019 0.4274966
#     NsiI-HF_BmtI-HF   73976 0.6494579 0.7535527 0.8104638 0.4288616
#    BmtI-HF_BsrGI-HF   82495 0.6379596 0.7416909 0.7940525 0.4249989
#     Ncol-HF_SpeI-HF   50099 0.6209818 0.7101891 0.7688251 0.4266475
#  SphI-HF_HindIII-HF   59087 0.6083162 0.7237793 0.7936078 0.4260153
#    PstI-HF_BamHI-HF   61948 0.6025895 0.7079678 0.7736854 0.4685101
#     BmtI-HF_MfeI-HF   65524 0.5961765 0.7123289 0.7769550 0.4203711
#    BmtI-HF_BamHI-HF   60782 0.5880201 0.7120477 0.7777566 0.4438481
#    NsiI-HF_BamHI-HF   51676 0.5849617 0.6838895 0.7453285 0.4440551
#     SphI-HF_MfeI-HF   77937 0.5838678 0.7082790 0.7837594 0.4261088
#    SphI-HF_BamHI-HF   62513 0.5778720 0.6869057 0.7473095 0.4539773
#    KpnI-HF_BsrGI-HF   54034 0.5728745 0.6782780 0.7438009 0.4238806
#     BmtI-HF_KpnI-HF   71959 0.5524429 0.6759788 0.7470998 0.4403046
#     MfeI-HF_SpeI-HF   64895 0.5491992 0.6606219 0.7396398 0.4261128
#  HindIII-HF_MfeI-HF   92544 0.5315447 0.6526010 0.7316663 0.4146115
#     KpnI-HF_SphI-HF   76238 0.5225571 0.6311311 0.6938184 0.4551178
#     KpnI-HF_MfeI-HF   57117 0.4862988 0.6038219 0.6833822 0.4401999
#  HindIII-HF_Ncol-HF   96312 0.4721892 0.5799522 0.6554641 0.4320567
#     PstI-HF_KpnI-HF   68551 0.4375137 0.5252990 0.5957498 0.4558078
#
# Higher uniqueness at the beginning or end of a fragment may not correspond
# with better mappability, but it could. There is a large variation in
# uniqueness, and I am inclined to choose an enzyme combination from the
# top of the list.

