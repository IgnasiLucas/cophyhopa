dist.mat <- t(acast(assem2_outstat, INDV1~INDV2, value.var = 'RELATEDNESS_AJK', fill = 0))
dm <- pmax(dist.mat, 0)
njt1 <- nj(dm)
njt2 <- bionj(dm)

plot.phylo(njt2, show.tip.label = FALSE)

plot(njt1)


