
## Creating Population attributes table

library(GWASTools); library(ggplot2); library(SNPRelate); library(stringr); 
setwd("~/cophyhopa/results/2022-05-09/SNPRelate")
vcf <- snpgdsVCF2GDS("~/cophyhopa/results/2022-05-04/assem2_indv2.recode.vcf", 
                     "~/cophyhopa/results/2022-05-09/SNPRelate/all_geno.gds", 
                     method = "biallelic.only")

all_samp <- snpgdsOpen("all_geno.gds")
#snpgdsClose(all_geno)

DATA <- '../../../data/Fish_clean.tsv'
Fish <- read.table(DATA, header = TRUE)
row.names(Fish) <- Fish$Fish_code
fish <- data.frame(Fish$Sci_name_CONSENSUS_ID, 
                   Fish$MOL_MORPH_CONSENSUS_ID,
                   row.names = rownames(Fish))

for (i in 1:nrow(fish)) {
  if(is.na(fish[i,1])) {
    fish[i,1] <- fish[i,2]
  }
}

## Add population information 
popmap <- read.delim("~/cophyhopa/data/old_popmap.txt", header=FALSE)
samp <- snpgdsGetGeno(all_samp, sample.id = NULL, with.id = TRUE)

sample.id <- samp$sample.id
row.names(popmap) <- popmap[,1]

popmap[, 3] <- NA
popmap <- popmap[sample.id, ] 
popmap[, 3] <- fish[rownames(popmap), ]

## Add lakes information 
popmap[, 4] <- NA
colnames(popmap) <- c("sample", "group", "sp", "lake")

library(stringr)
for(i in 1:nrow(popmap)){
  popmap[i, 4] <- substr(popmap[i, 2], 1, 3)
}

head(popmap)

write.table(popmap, file = '~/cophyhopa/data/popmap.txt', 
            row.names = FALSE, col.names = FALSE)

# Creating the tables for separate analysis for the two regions
samp_used <- samp$sample.id
Fish.alpine <- intersect(samp_used, row.names(Fish[Fish$Region == 'Alpine',]))
Fish.arctic <- intersect(samp_used, row.names(Fish[Fish$Region == 'Arctic',]))
write.table(Fish.alpine, file = 'Alpine.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)
write.table(Fish.arctic, file = 'Arctic.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)

#-----------------LAKES SAMPLES-------------------------

# Creating the tables for separate analysis for the two regions

DATA <- '../../../data/Fish_clean.tsv'
Fish <- read.table(DATA, header = TRUE)
row.names(Fish) <- Fish$Fish_code
popmap <- read.delim("~/cophyhopa/data/old_popmap.txt", header=FALSE)
samp_used <- popmap[,1]

Walen <- intersect(samp_used, row.names(Fish[Fish$Lake == 'Walen',]))
write.table(Walen, file = '~/cophyhopa/data/Walen.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)

Zurich <- intersect(samp_used, row.names(Fish[Fish$Lake == 'Zürichsee',]))
write.table(Zurich, file = '~/cophyhopa/data/Zurich.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)

Thun <- intersect(samp_used, row.names(Fish[Fish$Lake == 'Thun',]))
write.table(Thun, file = '~/cophyhopa/data/Thun.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)

Brienz <- intersect(samp_used, row.names(Fish[Fish$Lake == 'Brienz',]))
write.table(Brienz, file = '~/cophyhopa/data/Brienz.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)

Bienne <- intersect(samp_used, row.names(Fish[Fish$Lake == 'Bienne',]))
write.table(Bienne, file = '~/cophyhopa/data/Bienne.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)

#-------------- HYBRIDS --------------------------------------

WalZur <- readLines("~/cophyhopa/results/2022-05-09/SNPRelate/Hybrids_walzur.txt")
BBT <- readLines("~/cophyhopa/results/2022-05-09/SNPRelate/Hybrids_bbt.txt")
HYBRIDS <- c(WalZur, BBT)
write.table(HYBRIDS, file = '~/cophyhopa/data/HYBRIDS.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)

#-----------------SAMPLES ID SPECIES -------------------------

poptable <- read.table('~/cophyhopa/data/popmap.txt', 
                  col.names = c('sample', 'group', 'pop', 'lake'))
head(poptable)

pop <- as.character(unique(poptable$pop))
write.table(pop, file = '~/cophyhopa/data/pop_sp/pop_sp_list.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)
rownames(poptable) <- poptable[,1]
head(poptable)


sp <- list(NA)
for (i in 1:length(pop)) {
  sp[[i]] <- poptable[which(poptable[,3] == pop[i]), ]
}

C.zuerichensis = sp[[1]]
C.heglingus = sp[[2]]
C.confusus = sp[[3]]
C.brienzii = sp[[4]]
C.brienzii/C.fatioi = sp[[5]]
C.fatioi = sp[[6]]
C.albellus = sp[[7]]
C.alpinus = sp[[8]]
P = sp[[9]]
L = sp[[10]]
D = sp[[11]]
C.acrinasus = sp[[12]]
C.steinmanni = sp[[13]]
C.alpinus/C.steinmanni = sp[[14]]
C.fatioi/C.albellus = sp[[15]]
C.profundus = sp[[16]]
C.duplex = sp[[17]]

##----------------------------------------------------------------------------------------------------------------

#Create the Treemix popmap for the trees (first with D as outgroup, then P and L) -- In the readme 

poptable <- read.table('~/cophyhopa/data/popmap.txt', 
                       col.names = c('sample', 'group', 'pop', 'lake'))
head(poptable)
poptable$lake <- NULL
poptable$group <- poptable$sample
poptable <- poptable[-which(poptable$pop == "L"),]
poptable <- poptable[-which(poptable$pop == "P"),]
write.table(Bienne, file = '~/cophyhopa/data/Bienne.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)


## ------------------------------------------------

## ALL ALPINE SPECIES WITH MORE OF 10 INDIVIDUALS 

poptable <- read.table('~/cophyhopa/data/popmap.txt', 
                       col.names = c('sample', 'group', 'pop', 'lake'))

which(poptable[,3] == "C.alpinus")
poptable <- poptable[-which(poptable[,3] == "C.alpinus"), ]
poptable <- poptable[-which(poptable[,3] == "C.alpinus/C.steinmanni"), ]
poptable <- poptable[-which(poptable[,3] == "C.brienzii"), ]
poptable <- poptable[-which(poptable[,3] == "C.fatioi/C.albellus"), ]
poptable <- poptable[-which(poptable[,3] == "D"), ]
poptable <- poptable[-which(poptable[,3] == "L"), ]
poptable <- poptable[-which(poptable[,3] == "P"), ]

write.table(poptable, file = '~/cophyhopa/data/popAlpine_RI.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)

write.table(poptable[,1], file = '~/cophyhopa/data/Alpine_Indv.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)



## BRI THU AND BIE SPECIES WITH MORE OF 10 INDIVIDUALS 

poptable <- read.table('~/cophyhopa/data/popmap.txt', 
                       col.names = c('sample', 'group', 'pop', 'lake'))

which(poptable[,3] == "C.alpinus")
poptable <- poptable[-which(poptable[,3] == "C.alpinus"), ]
poptable <- poptable[-which(poptable[,3] == "C.alpinus/C.steinmanni"), ]
poptable <- poptable[-which(poptable[,3] == "C.brienzii"), ]
poptable <- poptable[-which(poptable[,3] == "C.fatioi/C.albellus"), ]
poptable <- poptable[-which(poptable[,3] == "D"), ]
poptable <- poptable[-which(poptable[,3] == "L"), ]
poptable <- poptable[-which(poptable[,3] == "P"), ]
poptable <- poptable[-which(poptable[,3] == "C.duplex"), ]
poptable <- poptable[-which(poptable[,3] == "C.heglingus"), ]
poptable <- poptable[-which(poptable[,3] == "C.zuerichensis"), ]

write.table(poptable[,1], file = '~/cophyhopa/data/BTB_INDV.txt', quote = FALSE,
            row.names = FALSE, col.names = FALSE)
