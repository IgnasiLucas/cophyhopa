# 2022-12-29
Estimation of Fst between species of Balchen and Felchen ecomorphs from the same
lake (in Switzerland) or between species of ecomorphs L and P from the same lake
in Norway. Our results show some overlap of high-Fst regions across lakes, and
even some across lakes from different regions. However, for those overlaps to
be found, the threshold of what is considered "high" Fst must not be very high.
Just around the 95th or 96th percentile.

See [a wonderful report here](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-12-29/README.html)

# 2022-12-23
Estimation of Fst between species of the same ecomorph from different lakes. This
comparison may be useful later. It is not finished.

# 2022-12-20
I use `bedtools` to identify the subset of loci with enough coverage in all samples
directly from the BAM files.

This is based on the re-duplicated BAM files, created in 2022-12-16 in order to revert the
collapse of redundant reads made by ipyrad in the original mappings. The <species>/common.loci
files include loci covered by at least 6 reads of every sample in that species (after
excluding the very low-coverage samples previously identified). The <species>/merged.loci
is the union of loci covered at least 6 times in any sample of that species. There
are also shared.loci and merged.loci for all species. Extremely highly covered loci
have not been excluded. 

# 2022-12-16
For the purpose of estimating the allele frequency spectra (AFS), I revise the coverage
profiles and realised that at least three chromosomes (22, 32 and 38) seem to be duplicated
and some others (4, 28, 35, 37 and 40) could have partial duplications not represented
or collapsed in the reference genome. According to the authors of the reference genome,
chromosomes suspected to be affected by collapsed duplicated regions are: 4, 7, 17, 22,
28, 32, 35, 37 and 38. Given the fragmentary nature of our sequence data, as well as the
overdispersion caused by the PCR step in library preparation, and the spurious presence
of small fragments with low coverage, it is impossible to use our coverage data to identify
with precision the duplicated regions. Having confirmed the suspicion of collapsed duplication
in some of the chromosomes (in all species), it seems a good idea to exclude all chromosomes
with potential collapsed duplications from the analysis.

Curiously, the coverage grows with fragment length until about a length of 200 and then
it decreases (not shown in report). This is probably caused by the size-selection step in
library preparation.

Currently obtaining species-specific VCFs with freebayes. The report will be
[available in this link.](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-12-16/README.html)

# 2022-12-14
Just curious about the mapping quality performed by ipyrad. I confirm that mapping to a reference
makes the clustering threshold irrelevant. I show that the two samples from the most distant
clades, in Suopatjavri and Langjordvatn, have mapping qualities just as good as a sample from
the same species as the reference, C. steinmanni.

See the [report in this link](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-12-14/report.html).

# 2022-09-21

# 2022-07-23
I finally managed to run fastsimcoal2, using the estimated site frequency spectra of
the two arctic populations. The first and very simple models fitted suggest that
Suopatjavri holds a much smaller population than Langfjordvatn, and that they are
very different, probably due to a long time of divergence. In the last runs, I made
sure monomorphic SNPs are not taken into account. But the SFS from Langfjordvatn may
be biased and need to be checked.

See the [report in this link](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-07-23/README.html).

# 2022-06-15


# 2022-06-02
Here Mar uses Treemix to get the populations tree, and to infer migration events.
You can see [the report in this link](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-06-02/README.html).

# 2022-05-27
Using Adegenet to replicate the PCA. I take advantage of the species labeling,
ignoring lakes for the moment. The correspondence between putative species and
clusters in the PCA is much better than I expected in the Alpine lakes. I cannot
say the same for the Arctic ones, which have not been named, but labeled with
three letters of misterious meaning (D, L, P).

See [the report in this link](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-05-27/README.html).

# 2022-05-09
## 2022-05-09/admixture
First attempt at an admixture analysis. Check the report
[in this link](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-05-09/admixture/README.html).

## 2022-05-09/angsd
A failed attempt to use angsd for PCA analysis. Work on progress.

## 2022-05-09/fineRADstructure
Clustering of individuals with fineRADstructure. There is a
[report of how the analysis was performed](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-05-09/fineRADstructure/README.html),
but the most interesting results are in the `plots` folder.

## 2022-05-09/SNPRelate
This is a PCA performed with the SNPRelate package. There is an analysis
[of the whole data set](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-05-09/SNPRelate/README.html),
and also [one of only the Alpine populations](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-05-09/SNPRelate/Swiss/README.html).

One problem with the PCA plots is that keeping individuals from the same putative
species but different lakes separate blows up the number of colors we need to
represent every population.

# 2022-05-04
We take the VCF output from ipyrad (2022-04-22) and filter it. First we identify
the individuals with lowest coverage, and remove 5 of them. Then, we thin out
loci and remove those with more than 12 individuals with missing data. We end
up with 22270 loci, with much more complete information. We identify 4 more
individuals that do not reach 90% of loci with data. We repeat the filtering from
the beginning, removing the first five and the other 4, namely, we remove:
BRZ066, BRZ111, SUO095, THU066, THU199,  BRZ108, BRZ110, LAN029 and SUO083.
And then filter sites again, allowing for up to 12 individuals with missing
data per site. We end up with 24878 loci, with only two individuals
(BRZ045 and BIE006) with more than 10% of missing data (but less than 15%).

The report of this analysis can be checked [in this link](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-05-04/README.html).

# 2022-04-29
This folder assigns 'population'codes to sample identifiers. In principle, we
combined the morphological assignation of species with the lake, because
individuals from the same species but in different lakes cannot be in Hardy-
Weinberg equilibrium, for example, and for testing this or for other purposes
we wanted to keep lakes identified in the population code.

# 2022-04-22
Here, ipyrad finishes, by merging the assemblies from the two sequencing runs.
The output files include a VCF. Reads had been mapped to the reference quite
successfully. There are 195366 loci identified. Samples have data, on average,
in 61477 loci. There are no parsimony-informative sites in 112432 loci. Among
the other 82934 loci, there are 879238 variable sites, 496712 of them parsimony-
informative. 

There is no html report here, and the folder is not automatically reproducible,
since it lacks a README.sh or a README.Rmd file. We apologize.

# 2022-04-01
Here we run ipyrad using as input the symbolic links prepared in 2021-12-21
(for the file names to be directly interpretable as sample names and read number).
Only the first steps are run, separately for the datasets from the two sequencing
runs. A merging of those two "assemblies" is attempted in ipyrad, but then it is
moved to folder 2022-04-22.

This folder is not automatically reproducible. It lacks a README.sh or README.Rmd
file. There is no final report.

# 2022-01-26
Between the two sequencing runs we got 2.447.193.170 pairs of reads assigned
to real samples. See the [report here](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-01-26/README.html).

# 2022-01-19
To present results of the quality control of fastq files, the images in
the report in `2021-11-29` are not all that informative or representative.
I decided to make movies with the png files of the different reports. That
way we can see better how samples compare among themselves and where the
low-quality bases are. There is no html report in this folder, but you
can enjoy the movies.

# 2022-01-18
Repeating the VSEARCH analysis from `2022-01-10`, but trying to cluster
merged and non-merged forward reads separately.

It didn't work. It just takes way too long clustering. I abandon this
strategy. Next thing is to run ipyrad. Results are erased to save space.

See the [report here, anyways.](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-01-18/README.html)

# 2022-01-10
Using VSEARCH to merge, filter, de-replicate and cluster reads, in order to
count the number of loci that got sequenced. The strategy was: first to merge
read pairs that could be merged (around 50%). Then, filter merged reads and
forward members of non-merged pairs by expected errors. De-replicate and add
sample information to fasta files. And cluster. Many non-merged forward reads
became filtered out, presumably because of errors that could have been trimmed.
Trimming is recommended for mapping purposes. Another limitation was to use
an absolute number of expected errors (1) as filtering threshold, instead of
a *rate* of expected errors, because merged reads differ in length.

Finally, the clustering was interrupted due to lack of enough RAM. I abandon
this strategy. See the [report here](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2022-01-10/README.html)

I erased the contents of folders `merged`, `paired`, and `derep`, which were
using too much disk space. For the moment, I keep `paired.clean` and `merged.clean`,
but may remove them as well later.

# 2021-12-21
Preparing to run ipyrad from RStudio. You can see 
[the report herer](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2021-12-21/README.html)

# 2021-12-13
Using numbers of reads from both sequencing runs, I model the amount of index
hopping in mock samples, where all reads observed are misassigned. The best
predictor of the number of reads misassigned to a combination of i5 and i7
indices is the product of the concentrations of those i5 and i7 indices in
the pool. That is, the **product** of the total number of reads sharing the i5
and the total number of reads sharing that i7. The fact that the product of
those numbers predict index hopping level better than their sum makes me think
that index hopping happens frequently by misassignment of both indices.

The model achieves an adjusted R-squared of 0.9874. The predicted amounts of
index hopping in real samples are below 5% in all samples but in the one with the
lowest amount of reads (SUO095: 18% of index hopping in 167111 reads).

See the [report here](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2021-12-13/README.html)

# 2021-11-29
Quality analysis.

See the [report here](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2021-11-29/README.html)

# 2021-11-26
The k-mer analysis shows a distribution of k-mer abundances similar to a mixture
of two components: a large fraction of words read relatively few times (but
still a lot) and a core of words with a more or less normal coverage of
around 100. I take the first sporadic words to be those with sequencing errors,
contamination and out-of-range fragments, while the second component must represent
the DNA fragments targeted. Of course, there is also a long tail of highly repetitive
words.

The sporadic component is not explained by reverse reads only, or by reads from
lane 2 (supposed to be more noisy).

K-mer and GC-content show quite homogeneous nature of the DNA sequenced.

The comparison of k-mer frequencies among samples confirm a strong correlation,
giving support to the hope of having sequenced a large enough portion of common
loci.

The k-mer analyses could be extended to compare reads to the reference genome,
or to repeat it after de-replicating the reads. But we need to move on. See the
[report here](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2021-11-26/README.html)

# 2021-11-23
We just received the first batch of sequences, with a note that a second lane did
not produce very good quality output, and a promise to repeat the sequencing.
From the overview of the numbers of reads per sample, it seems the sequencing
effort got quite well distributed among samples. We can also see low, but
positive, levels of cross contamination from the numbers of reads assigned
to not used combinations of indices.

Downloaded the reads in data/fastq. I re-counted the reads per sample and
put together a table "Features" with information from all aspects of the
samples: fish features, DNA extraction success, position in plates and
number of reads. It includes the 104 mock samples. Just started using it
to explore the determinants of the number of reads.

See [this report](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2021-11-23/README.html).

# 2021-10-27
We received the Bioanalyser results from the 5 pools, with similar profiles,
and I decide to use equivalent amounts of DNA in the target size range from
the 5 pools to make the final pool. See [the report here](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2021-10-27/README.html).

# 2021-10-13
Assignment of samples to indices, according to distribution of samples in
the 96-well plates reported by Alan. See [this report](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2021-10-13/README.html)

# 2021-10-08
The DNA libraries are prepared. Eleven of them were analysed in Bioanalyser for
quality control. The concentrations of all them are also determined with Qubit.
A strong positive correlation exist between Qubit and Bioanalyser measures, with
Bioanalyser being more optimistic. The average standard deviation between Qubit
and Bioanalyser estimates of concentration is 0.27 ng/µl, which is high (the average
concentration is almost 1 ng/µl). I realize that measuring error in Qubit and
pipetting errors can undermine the leveling of DNA amounts among samples: even if
we cannot get equal DNA amounts if we pool more than 4 ng per sample (4 is the minimum),
the noise introduced by measuring errors could be more dramatic than the lack of
enough DNA in some samples, to the point that I recommend now to use 10 ng of DNA
per sample, or the total amount if 10 are not available. I expect to get a less
variable distribution of coverage per sample this way. See the report at
[here](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2021-10-08/README.html)

# 2021-07-05
I compare the fluorescence profile obtained with a Bioanalyser of a product of
double digestion with the expected profile from the in silico digestions. I conclude
the in vitro digestion resembles enough the in silico one to be trusted, and
determine that the number of fragments with different ends in the size range
that can be sequenced is not likely to be larger than expected. Thus, I am
inclined to select as wide a size range as possible for sequencing. See the
report [here](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2021-07-05/README.html)

# 2021-01-14
There is an overview of the protocol [here](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2021-01-14/protocol.html).
There are also pdf documents describing the adapters design and the detailed protocol.
This is updated as the experiment proceeds.

# 2020-12-14
In silico digestions of a reference genome to inform the choice of restriction enzymes.

# 2020-11-12
Preliminar in silico digestions.
