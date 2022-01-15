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
the 5 pools to make the final pool.

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
