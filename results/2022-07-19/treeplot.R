library(ape)

t <- read.tree("testTREE.treefile")

t <- read.tree("testTREE.bionj")


plot.phylo(t, cex = 0.5)

t <- read.tree("~/cophyhopa/results/2022-07-19/TREE.bionj")

#----
contree <- read.tree("~/cophyhopa/results/2022-07-19/TREE2.contree")
plot.phylo(contree, cex = 0.5)

outgroup <- read.table('~/cophyhopa/results/2022-07-07/poparc.txt', col.names = c('sample', 'pop'))
outgroup <- as.character(outgroup[,1])

contree <- root.phylo(contree, outgroup = outgroup)
png(filename = "contree.png", width = 9000, height = 13000, units = "px", res = 850)
plot.phylo(contree, cex = 0.5)
dev.off()



#---- 
tree <- read.tree("~/cophyhopa/results/2022-07-19/TREE2.treefile")
plot.phylo(tree, cex = 0.5)
tree <- root.phylo(tree, outgroup = outgroup)

outgroup <- read.table('~/cophyhopa/results/2022-07-07/poparc.txt', col.names = c('sample', 'pop'))
outgroup <- as.character(outgroup[,1])

png(filename = "tree.png", width = 9000, height = 13000, units = "px", res = 850)
plot.phylo(tree, cex = 0.5, show.node.label = TRUE)
dev.off()
