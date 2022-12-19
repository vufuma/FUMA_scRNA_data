# This script combines all the files in one folder

#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

working_dir = args[1]
gene_file = args[2]
outfile = args[3]

setwd(working_dir)

file_list <- list.files(pattern = "magma_input.txt")

dataset = read.table(gene_file, header = TRUE)

for (file in file_list){
  temp_dataset <-read.table(file, header=TRUE, sep="\t")
  dataset<-merge(dataset, temp_dataset,by="GENE")
  rm(temp_dataset)
}

#compute AVERAGE
dataset$Average = apply(dataset[,2:ncol(dataset)], 1, mean)
write.table(dataset, outfile, row.names = FALSE, quote = FALSE)