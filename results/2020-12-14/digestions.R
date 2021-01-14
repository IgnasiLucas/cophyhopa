library(SimRAD)
library(dplyr)

args <- commandArgs(trailingOnly=TRUE)
combinacions <- read.table('combinacions.txt', header=TRUE, as.is=TRUE)
combiancions <- combinacions[args[1]:args[2],]

#....

write.table(results, file=paste('digestions', args[1], '.txt', sep=''), quote=FALSE)


## Llegir l'arxiu dels segments _ 0.25% del DNA
digestions <- read.table("~/cophyhopa/results/2020-11-20/digestions_all.txt", sep = "/")

# Seleccionar les combinacions amb més segments i crear una llista amb el nº de segm
higher_seg <- digestions > 12500
lower_seg <- digestions < 12505
segments <- digestions[higher_seg]
segments <- segments[lower_seg]

# Quina es la posició de les combinacions d'enzims que donen el major nº de seg
loc_enzims <- which(higher_seg == TRUE, lower_seg == TRUE)

list_rec.cs <- list_cs[loc_enzims]

## Crear la funció que digereixi i seeccioni els fragments
refseq <- SimRAD::ref.DNAseq("~/cophyhopa/data/reference.fa", subselect.contigs = FALSE)

cores <- detectCores()
cl <- makeForkCluster(16)
clusterExport(cl, "refseq", envir = .GlobalEnv)

digest_select <- function(x) {
  digestio <- SimRAD::insilico.digest(refseq, x[["cs_5p1"]], x[["cs_3p1"]], x[["cs_5p2"]], x[["cs_3p2"]])
  seleccio1 <- SimRAD::adapt.select(digestio, type='AB+BA', x[["cs_5p1"]], x[["cs_3p1"]], x[["cs_5p2"]], x[["cs_3p2"]])
  seleccio2 <- SimRAD::size.select(seleccio1, min.size=500, max.size=1000, graph=FALSE, verbose=FALSE)
  length.select <- length(seleccio2)
  return(length.select)
}
t <- proc.time()

digestions_51 <- parallel::parLapply(cl, list_rec.cs, digest_select)
#stopCluster()

proc.time()-t

write.table(digestions_51, file="digestions_51_all.txt", 
            row.names=FALSE, col.names=FALSE, sep= " / ")

max_length <- which(digestions_51 == max(unlist(digestions_51)))




