results <- dir('digestions')
names(results) <- gsub('.txt', '', results)
digests <- lapply(results, function(x) read.table(paste('digestions/', x, sep=''))[,1])
sizeSelected <- sapply(digests, function(x) sum(x[250:650]))
candidates <- sizeSelected[sizeSelected > 50000 & sizeSelected < 100000]
write.table(candidates, file='candidates.txt', quote=FALSE, col.names=FALSE)