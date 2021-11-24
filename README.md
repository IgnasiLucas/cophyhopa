# 2021-11-23
We just received the first batch of sequences, with a note that a second lane did
not produce very good quality output, and a promise to repeat the sequencing.
From the overview of the numbers of reads per sample, it seems the sequencing
effort got quite well distributed among samples. We can also see low, but
positive, levels of cross contamination from the numbers of reads assigned
to not used combinations of indices.

Downloading the reads in data/fastq. Here I plan to perform quality control,
and maybe k-mer analyses. The number of files is huge...

I will update [this report](https://htmlpreview.github.io/?https://github.com/IgnasiLucas/cophyhopa/blob/soca/results/2021-11-23/README.html)

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
