
setwd("~/cophyhopa/results/2021-11-29")
library(fastqcr)

fastqc(fq.dir = "~/cophyhopa/data/fastq", qc.dir = "~/cophyhopa/results/2021-11-29/reports", 
       threads = 40, fastqc.path = "/usr/local/bin/fastqc")

qc.files <- list.files(path = "~/cophyhopa/results/2021-11-29/reports", all.files = FALSE, full.names = TRUE, pattern = "zip")
all <- qc_read_collection(files = qc.files, sample_names = qc.files, modules = "all")
QS <- qc_plot_collection(all, modules = "sequence quality")
qc_plot_collection(all, modules = "all")

# Aggregating multiple FastQC reports into a data frame 
qc.dir = "~/cophyhopa/results/2021-11-29/reports"
qc <- qc_aggregate(qc.dir, progressbar = TRUE)
qc.sum <- summary(qc)
qc.stat <- qc_stats(qc)


## Inspecting problems 
# See which modules failed in the most samples 
module <- qc_fails(qc, "module")
# See which samples failed the most 
samples <- qc_fails(qc, "sample")

# Building multi QC reports 
multiReport <- qc_report(qc.dir, result.file = "/gata/mar/cophyhopa/results/2021-11-29/multiQCreport")
# Building one-sample QC reports (+ interpretation)
qc.file <- "~/cophyhopa/results/2021-11-29/reports/BRZ013_12390AAC_TCCTGAGC-CGGAGAGA_R1_001_fastqc.zip"
qc_report(qc.file, result.file = "onesample_report", interpret = FALSE)



# With ngsReports package 

#Installation 
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("ngsReports")

library(ngsReports)
qc.files <- list.files(path = "~/cophyhopa/results/2021-11-29/reports", all.files = FALSE, 
                       full.names = TRUE, pattern = "zip")
fseq <- FastqcDataList(qc.files)

# Generating plots 












