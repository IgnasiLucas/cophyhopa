digestions299 <- read.table("~/cophyhopa/results/2021-1-19/digestions_299.txt", sep = "/")
combinations299 <- read.table("~/cophyhopa/results/2021-1-19/combinacions.txt", sep='\t')
# Transform the dataframe into a list
list_comb299 <- lapply(1:dim(combinations299)[1], function(x) combinations299[x,])

max(digestions299)
min(digestions299)

# Determine a range of values
range <- digestions299 > 55000 & digestions299 < 60000
inside_range <- digestions299[range]
length(inside_range)
# Which of 299combinations are inside the range, create a list with it
combi_range <- which(range == TRUE)
list_range59 <- list_comb299[combi_range]
index <- sapply(list_range59, row.names)
index
combinations59 <- combinations299[index,]
head(combinations59)

#Select those combinations with SbfI, EcoRI and PstI
enz1 <- str_extract(index, pattern = "EcoRI")
loc_enz1 <- which(enz1 == "EcoRI")
loc_enz1
enz2 <- str_extract(index, pattern = "SbfI")
loc_enz2 <- which(enz2 == "SbfI")
loc_enz2
enz3 <- str_extract(index, pattern = "PstI")
loc_enz3 <- which(enz3 == "PstI")
loc_enz3

final_combinations <- combinations59[loc_enz1,]
final_combinations


