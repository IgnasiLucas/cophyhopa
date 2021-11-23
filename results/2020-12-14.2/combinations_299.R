
## Definir 79 enzims de restricció 
# 1ª forma 
enzims <- read.table("~/cophyhopa/data/enzymes.txt", row.names = 1, col.names = c('enzims', 'Prime5', 'Prime3'), as.is = TRUE)

# Numero total d'enzims


# Combinem els enzims per parelles en un nou data frame amb la funció rep:
NumEnzims <- dim(enzims)[1]
combinacions_all <- data.frame(
  cs_5p1 = rep(enzims$Prime5, each=NumEnzims),
  cs_3p1 = rep(enzims$Prime3, each=NumEnzims),
  cs_5p2 = rep(enzims$Prime5, NumEnzims),
  cs_3p2 = rep(enzims$Prime3, NumEnzims),
  stringsAsFactors = FALSE
)
row.names(combinacions_all) <- paste(rep(row.names(enzims), each=NumEnzims),
                                     rep(row.names(enzims), NumEnzims),
                                     sep = '_')

z1 <- combn(row.names(enzims), 2)
z1 <- t(z1)
z1 <- as.data.frame(z1)
library(tidyr)
combinations <- unite(z1, combinacio, c(1:2), sep = "_", remove = TRUE)
comb_index <- combinacions_all[combinations[,1],] 
write.table(comb_index, file = "comb_index.txt")

list_cs <- lapply(1:dim(comb_index)[1], function(x) comb_index[x,])  #dimensió 1:x

--------

## Llegir l'arxiu dels segments _ 0.25% del DNA
digestions <- read.table("~/cophyhopa/results/2020-11-20/digestions_all.txt", sep = "/")

# Seleccionar les combinacions amb més segments i crear una llista amb el nº de segm
seg <- digestions > 12500 & digestions < 20000
segments <- digestions[seg]

# Quina es la posició de les combinacions d'enzims que donen el major nº de seg
loc_enzims <- which(seg == TRUE)
list_rec.cs <- list_cs[loc_enzims]

index <- sapply(list_rec.cs, row.names)
combinations299 <- combinacions_all[index,]

write.table(combinacions, file='combinacions299.txt', quote=FALSE, sep='\t')
