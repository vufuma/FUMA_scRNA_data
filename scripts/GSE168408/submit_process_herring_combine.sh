#!/bin/bash

#This script is to run the R script `process_herring_combine.R`

for level in level3; do
for stage in Adult Infancy Adolescence Fetal Childhood Neonatal; do
Rscript process_herring_combine.R ${level}/${stage}/ genes_for_merging.txt GSE168408_Human_Prefrontal_Cortex_${level}_${stage}.txt
done;
done;