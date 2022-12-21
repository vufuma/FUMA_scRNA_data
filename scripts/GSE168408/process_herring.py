# This script prepares the herring et al. 2022 human prefrontal cortex data
import scanpy as sc
import pandas as pd
import os
from collections import defaultdict

# create a list of barcode per stage
# I need to remap the barcode the the stage because of the error

# generate a dictionary of id and stage from sheet c of the supplement
supplement_info = pd.read_excel("mmc1.xlsx", sheet_name="C") #this is the supplementary table downloaded from the article
sampleid_stage_dict = dict(zip(supplement_info["snRNA-seq library ID"], supplement_info["Stage"]))

#
metadata_fn = "Processed_data_RNA-all_BCs-meta-data.csv" #this is the file downloaded from https://console.cloud.google.com/storage/browser/neuro-dev/Processed_data
metadata = pd.read_csv(metadata_fn)# read in the csv file
metadata['correct_stage']= metadata['RL#'].map(sampleid_stage_dict)

# read scanpy data
scrnaseq_data_fn = "Processed_data_RNA-all_full-counts-and-downsampled-CPM.h5ad" #this is the file downloaded from https://console.cloud.google.com/storage/browser/neuro-dev/Processed_data

# load scanpy object
scrna_data = sc.read_h5ad(scrnaseq_data_fn)

# get dimentions
# get number of cells
n_cells = scrna_data.shape[0] #154748, this is consistent with what is reported in the paper

# get all cell_type (level1)
cell_type = set()
for i in metadata['cell_type']:
    if i != "Poor-Quality":
        cell_type.add(i)

# get all major_clust (level2)
major_clust = set()
for i in metadata['major_clust']:
    if i != "Poor-Quality":
        major_clust.add(i)

# get all sub_clust (level3)
sub_clust = set()
for i in metadata['sub_clust']:
    if i != "Poor-Quality":
        sub_clust.add(i)

# get all stages
all_stages = set()
for i in metadata["stage_id"]:
    all_stages.add(i)

# level 1 cell_type
for ct in cell_type:
    for stage in all_stages:
        stage_data = metadata[metadata["correct_stage"] == stage]
        stage_data_ct = stage_data[stage_data["cell_type"] == ct]
        # get a list of barcode
        barcode = stage_data_ct["Unnamed: 0"].tolist()
        # subset
        scrna_data_subset = sc.get.var_df(scrna_data, keys=barcode)
        #save
        out_fn = os.path.join("level1/", ct + "_" + stage + ".csv")
        scrna_data_subset.to_csv(out_fn, index_label="Gene")

# level 2 major_clust
for ct in major_clust:
    for stage in all_stages:
        stage_data = metadata[metadata["correct_stage"] == stage]
        stage_data_ct = stage_data[stage_data["major_clust"] == ct]
        # get a list of barcode
        barcode = stage_data_ct["Unnamed: 0"].tolist()
        # subset
        scrna_data_subset = sc.get.var_df(scrna_data, keys=barcode)
        #save
        out_fn = os.path.join("level2/", ct + "_" + stage + ".csv")
        scrna_data_subset.to_csv(out_fn, index_label="Gene")

# level 3 sub_clust
for ct in sub_clust:
    for stage in all_stages:
        stage_data = metadata[metadata["correct_stage"] == stage]
        stage_data_ct = stage_data[stage_data["sub_clust"] == ct]
        # get a list of barcode
        barcode = stage_data_ct["Unnamed: 0"].tolist()
        # subset
        scrna_data_subset = sc.get.var_df(scrna_data, keys=barcode)
        #save
        out_fn = os.path.join("level3/", ct + "_" + stage + ".csv")
        scrna_data_subset.to_csv(out_fn, index_label="Gene")