enzims <- read.table("../../data/enzymes.txt", row.names = 1,
                     col.names = c('enzims', 'Prime5', 'Prime3'),
                     as.is = TRUE)
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
combinations <- paste(z1[,1], z1[,2], sep='_')
list_cs <- lapply(combinations, function(x) combinacions_all[x,])
write.table(combinacions_all[combinations,], file='combinacions.txt', quote=FALSE, sep='\t')
