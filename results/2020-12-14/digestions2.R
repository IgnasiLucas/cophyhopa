suppressMessages(library(SimRAD))
args <- commandArgs(trailingOnly=TRUE)
refseq <- ref.DNAseq("~/cophyhopa/data/reference.fa", subselect.contigs = FALSE)
combination <- args[1]
cs_5p1 <- args[2]
cs_3p1 <- args[3]
cs_5p2 <- args[4]
cs_3p2 <- args[5]
digested <- insilico.digest(refseq, cs_5p1, cs_3p1, cs_5p2, cs_3p2, verbose=FALSE)
adapted  <- adapt.select(digested, type="AB+BA", cs_5p1, cs_3p1, cs_5p2, cs_3p2)
selected <- size.select(adapted, min.size=250, max.size=650, graph=FALSE, verbose=FALSE)
uniqueness15 <- (length(unique(subseq(selected, start=1, end=15))) +
               length(unique(subseq(reverse(selected), start=1, end=15)))) / (2 * length(selected))
uniqueness25 <- (length(unique(subseq(selected, start=1, end=25))) +
               length(unique(subseq(reverse(selected), start=1, end=25)))) / (2 * length(selected))
uniqueness35 <- (length(unique(subseq(selected, start=1, end=35))) +
               length(unique(subseq(reverse(selected), start=1, end=35)))) / (2 * length(selected))
ACGTcontent <- colSums(letterFrequency(selected, c('A','C','G','T')))
CGcontent   <- sum(ACGTcontent[c('C','G')])/sum(ACGTcontent)

statistics <- data.frame(uni15 = uniqueness15,
                         uni25 = uniqueness25,
                         uni35 = uniqueness35,
                         CG    = CGcontent)
write.table(statistics, file = paste('digestions/', combination, '_stats.txt', sep=''), quote=FALSE, sep='\t', row.names=FALSE)
