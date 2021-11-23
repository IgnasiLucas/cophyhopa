
library(SimRAD)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
combinacions <- read.table("combinacions.txt", header = TRUE, as.is = TRUE)
combinacions <- combinacions[args[1]:args[2],]
list_cs2 <- lapply(1:dim(combinacions)[1], function(x) combinacions[x,])

## Crear la funció que digereixi i seeccioni els fragments
refseq <- SimRAD::ref.DNAseq("~/cophyhopa/data/reference.fa", subselect.contigs = FALSE)

digest_select <- function(x) {
  digestio <- SimRAD::insilico.digest(refseq, x[["cs_5p1"]], x[["cs_3p1"]], x[["cs_5p2"]], x[["cs_3p2"]])
  seleccio1 <- SimRAD::adapt.select(digestio, type='AB+BA', x[["cs_5p1"]], x[["cs_3p1"]], x[["cs_5p2"]], x[["cs_3p2"]])
  seleccio2 <- SimRAD::size.select(seleccio1, min.size=500, max.size=1000, graph=FALSE, verbose=FALSE)
  length.select <- length(seleccio2)
  return(length.select)
}

digestions299 <- lapply(list_cs2, digest_select)
digestions299 <- read.table("digestions_299.txt", col.names=FALSE, sep= "/")

write.table(digestions, file= paste("digestions", args[1], ".txt", sep = ""), 
            row.names=FALSE, col.names=FALSE, sep= " / ")






