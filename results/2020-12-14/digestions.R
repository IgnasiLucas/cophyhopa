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
sizeFreq <- tabulate(sapply(adapted,  nchar))
write.table(sizeFreq, file=paste("digestions/", combination, '.txt', sep=''), quote=FALSE)
