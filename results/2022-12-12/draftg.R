
## vcf

setwd("~/cophyhopa/results/2022-12-12")

# READ all Heterozygosity files
ALP <- c("C.zuerichensis", "C.heglingus", "C.confusus",
         "C.fatioi", "C.albellus", "C.acrinasus",  
         "C.steinmanni", "C.profundus", "C.duplex")

for (i in 1:length(ALP)) {
  assign(ALP[i], read.table(paste(ALP[i], ".het", sep = ""), header = TRUE, row.names = 1))
}

## other way
#for (i in ALP){
#  assign(i, read.table(paste(i, ".het", sep = ""), header = TRUE, row.names = 1))
#}

## ADD a new column with the species specification 
table_list <- list(C.zuerichensis, C.heglingus, C.confusus,
                   C.fatioi, C.albellus, C.acrinasus,  
                   C.steinmanni, C.profundus, C.duplex) #need to be in the same order as ALP

abs <- function(table, species) {
  table[,5] <- species
  colnames(table)[5] <- "SP"
  return(table)
} 

for (i in 1:length(table_list)) {
  assign(ALP[i], abs(table_list[[i]], ALP[i]))
}
  

ARC <- c("LAN_P", "LAN_D", "LAN_L", "SUO_L", "SUO_P")

for (i in 1:length(ARC)) {
  assign(ARC[i], read.table(paste(ARC[i], ".het", sep = ""), header = TRUE, row.names = 1))
}

table_list2 <- list(LAN_P, LAN_D, LAN_L, SUO_L, SUO_P)
for (i in 1:length(table_list2)) {
  assign(ARC[i], abs(table_list2[[i]], ARC[i]))
}


# necessari? 
ALPHET <- rbind(C.acrinasus, C.albellus, C.confusus, 
                C.duplex, C.fatioi, C.steinmanni, 
                C.heglingus, C.profundus, C.zuerichensis)
ARCHET <- rbind(LAN_P, LAN_D, LAN_L, SUO_L, SUO_P) 
ALLSAMPLES <- rbind(ALPHET, ARCHET)

## Boxplots amb la H observada al vcftools??????

## Càlculs per estimar la H esperada (percentatge per espècie)

head(ALLSAMPLES)
ALLSAMPLES$HETo <- (ALLSAMPLES$N_SITES - ALLSAMPLES$O.HOM.)/ALLSAMPLES$N_SITES
HETo_ALL <- ALLSAMPLES[, -1:-4]
head(HETo_ALL)

## Boxplot by species and lake 

# Convert SP into a vector 
HETo_ALL$SP <- factor(HETo_ALL$SP, levels = c("C.zuerichensis", "C.heglingus", 
                      "C.duplex", "C.fatioi", "C.albellus", "C.acrinasus",  
                      "C.steinmanni", "C.profundus", "C.confusus", "LAN_P", 
                      "LAN_D", "LAN_L", "SUO_L", "SUO_P"), ordered = TRUE)

# We need to include the column of lake in the df
POPMAP <- read.table("~/cophyhopa/data/popmap.txt", 
                     col.names = c("s", "grp", "pop", "lake"), 
                     row.names = 1, stringsAsFactors = FALSE)
POPMAP <- POPMAP[rownames(ALLSAMPLES),] ## filter the names that i don't want

HETo_ALL$LAKE <- NA
HETo_ALL[rownames(POPMAP), "LAKE"] <- POPMAP$lake
HETo_ALL$BASIN <- factor(NA, levels = c("WAL-ZUR", "THU-BRI", "BIE", "LAN", "SUO"))
HETo_ALL[HETo_ALL$LAKE %in% c("WAL", "ZUR"), "BASIN"] <- "WAL-ZUR"
HETo_ALL[HETo_ALL$LAKE %in% c("THU", "BRI"), "BASIN"] <- "THU-BRI"
HETo_ALL[HETo_ALL$LAKE %in% "BIE", "BASIN"] <- "BIE"
HETo_ALL[HETo_ALL$LAKE %in% "LAN", "BASIN"] <- "LAN"
HETo_ALL[HETo_ALL$LAKE %in% "SUO", "BASIN"] <- "SUO"

library(ggplot2)

ggplot(HETo_ALL, aes(SP, HETo, fill = BASIN)) + 
  geom_boxplot()



##########------------------------------------------------------------


##  IPYRAD 

setwd("~/cophyhopa/results/2022-04-22/assem2_clust_0.93")

PYHET <- read.table("s4_joint_estimate.txt", header = TRUE)
POPMAP <- read.table("~/cophyhopa/data/popmap.txt", 
                     col.names = c("s", "grp", "pop", "lake"), 
                     row.names = 1, stringsAsFactors = FALSE)
POPMAP <- POPMAP[rownames(ALLSAMPLES),]

PYHET <- PYHET[rownames(ALLSAMPLES),]
PYHET[,3] <- NA
PYHET[,4] <- NA
colnames(PYHET)[3:4] <- c("SP", "LAKE")
head(PYHET)

PYHET[rownames(ALLSAMPLES), "SP"] <- ALLSAMPLES$SP
PYHET[rownames(POPMAP), "LAKE"] <- POPMAP$lake
head(PYHET)
PYHET$SP <- factor(PYHET$SP, levels = c("C.zuerichensis", "C.heglingus", 
                   "C.duplex", "C.fatioi", "C.albellus", "C.acrinasus",  
                   "C.steinmanni", "C.profundus", "C.confusus", "LAN_P", 
                   "LAN_D", "LAN_L", "SUO_L", "SUO_P"), ordered = TRUE)
PYHET$LAKE <- factor(PYHET$LAKE, levels = c("WAL", "ZUR", "THU", "BRI", "BIE", "LAN", "SUO"))

PYHET$BASIN <- factor(NA, levels = c("WAL-ZUR", "THU-BRI", "BIE", "LAN", "SUO"))
PYHET[PYHET$LAKE %in% c("WAL", "ZUR"), "BASIN"] <- "WAL-ZUR"
PYHET[PYHET$LAKE %in% c("THU", "BRI"), "BASIN"] <- "THU-BRI"
PYHET[PYHET$LAKE %in% "BIE", "BASIN"] <- "BIE"
PYHET[PYHET$LAKE %in% "LAN", "BASIN"] <- "LAN"
PYHET[PYHET$LAKE %in% "SUO", "BASIN"] <- "SUO"


ggplot(PYHET, aes(SP, hetero_est, fill = BASIN)) + 
  geom_boxplot()



## CORRELATION BETWEEN MEANS 

head(HETo_ALL) ## output vcftools 
head(PYHET) ## output ipyrad 

species = c("C.zuerichensis", "C.heglingus", 
            "C.duplex", "C.fatioi", "C.albellus", "C.acrinasus",  
            "C.steinmanni", "C.profundus", "C.confusus", "LAN_P", 
            "LAN_D", "LAN_L", "SUO_L", "SUO_P")

MEANS <- matrix(NA, nrow = length(species), ncol = 2)
rownames(MEANS) <- species
colnames(MEANS) <- c("M_VCF", "M_PY")

for (i in 1:length(species)) {
  MEANS[rownames(MEANS) == species[i], "M_VCF"] <- mean(HETo_ALL$HETo[HETo_ALL$SP == species[i]])
  MEANS[rownames(MEANS) == species[i], "M_PY"] <- mean(PYHET$hetero_est[PYHET$SP == species[i]])
}
MEANS <- as.data.frame(MEANS)

ggplot(MEANS, aes(y = M_PY, x = M_VCF)) + 
  geom_point() + 
  geom_smooth(method = "lm", col = "black") + 
  theme_classic() 


