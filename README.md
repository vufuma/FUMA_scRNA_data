# FUMA scRNA-seq data sets

This is a github repository for pre-process script of scRNA-seq data sets used on FUMA web application ([http://fuma.ctglab.nl](http://fuma.ctglab.nl)).
Processed data sets can also be downloaded from this repository to run MAGMA by yourself.

## updates
* 19 Dec 2022:
Added: GSE168408 (Human Prefrontal Cortex scRNAseq dataset)
* 5 Aug 2019:
Updated citation
* 19th May 2019:  
Added: PsychENCODE, GSE97478, GSE106707
* 13th Feb 2019:  
Added: Allene Brain Atlas Cell Type second release,10X dataset   
Updated: Tabula Muris FACS
* 19th Jul 2018:  
First release

## Preparation of genes
### Human Ensembl genes (GRCh37 v92)
The list of genes with Ensembl ID are in ENSG.genes.txt

### Mapping of mouse gene ID to human gene ID
The script is available under scripts/mm2hs.R.
The output file is mm2hs.RData

## Information for preprocessing since 19 Dec 2022 update
### GSE168408
- Data downloaded from https://console.cloud.google.com/storage/browser/neuro-dev/Processed_data (downloaded on 16-12-2022)
- The data includes 3 levels:
+ level1 (called `cell_type`) in the metadata contains 3 cell types: PN, IN, and Non-Neu (did not consider Poor-Quality)
```
metadata_fn = "Processed_data_RNA-all_BCs-meta-data.csv"
metadata = pd.read_csv(metadata_fn)
metadata["cell_type"].unique()
<!-- array(['PN', 'IN', 'Non-Neu', 'Poor-Quality'], dtype=object) -->
```
+ level2 (called `major_clust`) in the metadata contains 18 cell types: 'L4_RORB', 'L2-3_CUX2', 'SST', 'Astro', 'L5-6_TLE4', 'L5-6_THEMIS', 'VIP', 'OPC', 'PV', 'PV_SCUBE3', 'ID2', 'Oligo', 'LAMP5_NOS1', 'Micro', 'Vas', 'MGE_dev', 'PN_dev', 'CGE_dev' (did not consider Poor-Quality)

+ level 3 (called `sub-clust`) in the metadata contains 86 cell types: 'L4_RORB_dev-2', 'L2-3_CUX2_dev-2', 'SST_CALB1_dev', 'Astro_dev-2', 'L5-6_TLE4_SCUBE1', 'L5-6_THEMIS_dev-2', 'VIP_ABI3BP', 'SST_STK32A', 'OPC_dev', 'SST_ADGRG6_dev', 'VIP_CHRM2', 'PV_dev', 'SST_BRINP3', 'PV_SCUBE3_dev', 'CCK_SYT6', 'ID2_dev', 'L5-6_TLE4_HTR2C', 'L4_RORB_MME', 'L5-6_TLE4_SORCS1', 'Astro_dev-1', 'L2-3_CUX2_dev-3', 'VIP_HS3ST3A1', 'LAMP5_NDNF', 'SST_B3GAT2', 'OPC_MBP', 'Astro_SLC1A2_dev', 'LAMP5_NOS1', 'SST_NPY', 'VIP_ADAMTSL1', 'VIP_DPP6', 'L2-3_CUX2_dev-6', 'PV_SULF1_dev', 'SST_TH', 'VIP_CRH', 'VIP_PCDH20', 'VIP_KIRREL3', 'L4_RORB_dev-1', 'L5-6_TLE4_dev', 'CCK_RELN', 'Astro_GFAP', 'LAMP5_CCK', 'Astro_dev-4', 'OPC', 'Micro', 'Vas_CLDN5', 'PV_SST', 'MGE_dev-1', 'L5-6_THEMIS_dev-1', 'ID2_CSMD1', 'PV_SULF1', 'L2_CUX2_LAMP5_dev', 'CCK_SORCS1', 'SST_ADGRG6', 'L5-6_THEMIS_NTNG2', 'L2-3_CUX2_dev-5', 'MGE_dev-2', 'PV_WFDC2', 'VIP_dev', 'SST_CALB1', 'L5-6_THEMIS_CNR1', 'Astro_SLC1A2', 'L2-3_CUX2_dev-1', 'L4_RORB_LRRK1', 'L2_CUX2_LAMP5', 'L4_RORB_MET', 'L3_CUX2_PRSS12', 'PV_SCUBE3', 'BKGR_NRGN', 'Oligo_mat', 'Micro_out', 'Oligo-4', 'Oligo-1', 'Vas_TBX18', 'Oligo-2', 'Oligo-5', 'L2-3_CUX2_dev-fetal', 'Oligo-3', 'L4_RORB_dev-fetal', 'L2-3_CUX2_dev-4', 'Vas_PDGFRB', 'PN_dev', 'CGE_dev', 'Astro_dev-3', 'Oligo-7', 'Astro_dev-5', 'Oligo-6'

### Step 1: Run a python script in order to get the gene expression per stage per celltype per level
```
python process_herring.py
```

### Step 2: Compute mean across all cells per stage per celltype per level
- Snakemake file: `process_herring.smk`
- Output: for each of the 3 levels, for each of the 6 stages, mean gene expression across all cells for that cell type

### Step 3: For each level, combine all cell types for each spage
- Because the number of rows are the same, I first create a file called `level2_genes.txt` that contains just the gene names. This file is used to merge. 
```
awk '{print$1}' level2/Adult/Astro_Adult_mean_magma_input.txt > genes_for_merging.txt
cat genes_for_merging.txt | wc -l
26671
```
- Use Rscript `process_herring_combine.R`
- Output: for each of the 3 levels, for each of the 6 stages, 1 file 

## Information for preprocessing up to 5 Aug 2019 update
### Data sets
The list of data sets are available at [FUMA tutorial page](http://fuma.ctglab.nl/tutorial#celltype).

Preprocess of each data set is available in one of the following R scripts.
1. Allen_Brain_Atlas_Cell_Type.R  
2 human and 3 mousebrain data sets from Allen Brain Atlas.
2. Allen_Brain_Atlas_Cell_Type_prev.R  
3 mouse data sets from Allen Brain Atlas (previously released datasets).
3. DroNc.R  
2 data sets (human and mouse) from Habib et al. Nat. Meth. (2017)
4. DropViz.R  
Data set from [http://dropviz.org](http://dropviz.org).
5. Linnarsson_MouseBrainAtlas.R  
Data sets from [http://mousebrain.org](http://mousebrain.org).
6. TabulaMuris.R  
2 data sets (FACS and droplet) from The Tabula Muris Consortium.
6. MouseCellAtlas.R  
Data set from [http://bis.zju.edu.cn/MCA/](http://bis.zju.edu.cn/MCA/).
8. Linnersson_lab.R  
Other data sets from Linnarsson's group.
9. 10X.R  
PBMC data set downloaded from 10X Genomics.
10. PsychENCODE.R  
2 data sets from PsychENCODE.
11. GEO.R  
Everything else.

### Additional process prior to the process in R scripts
#### 1. GSE67602 (Linnarsson's lab)
Metadata for cells were extracted from family soft file by the following commands.
```
echo -e "cell_id\tcell_type" > GSE67602_celltype.txt
gzip -cd GSE67602_family.soft.gz | grep Sample_title | sed 's/!Sample_title = //' > title.txt
gzip -cd GSE67602_family.soft.gz | grep "cell type level 1" | sed 's/!Sample_characteristics_ch1 = cell type level 1: //' > celltype.txt
paste title.txt celltype.txt >>GSE67602_celltype.txt
```
#### 2. GSE75330 (Linnarsson's lab)
Metadata for cells were extracted from family soft file by the following commands.
```
echo -e "cell_id\ttissue\tage\ttreatment\tcell_type" > GSE75330_metadata.txt
gzip -cd GSE75330_family.soft.gz | grep Sample_title | sed 's/^!Sample_title = //' >title.txt
gzip -cd GSE75330_family.soft.gz | grep Sample_source_name_ch1 | sed 's/^!Sample_source_name_ch1 = //' >tissue.txt
gzip -cd GSE75330_family.soft.gz | grep "= age:" | sed 's/^!Sample_characteristics_ch1 = age: //' >age.txt
gzip -cd GSE75330_family.soft.gz | grep "= treatment:" | sed 's/^!Sample_characteristics_ch1 = treatment: //' >treatment.txt
gzip -cd GSE75330_family.soft.gz | grep "inferred cell type:" | sed 's/^!Sample_characteristics_ch1 = inferred cell type: //' >celltype.txt
paste title.txt tissue.txt age.txt treatment.txt celltype.txt >>GSE75330_metadata.txt
```
#### 3. GSE78845 (Linnarsson's lab)
Metadata for cells were extracted from family soft file by the following commands.
```
echo -e "cell_id\tcell_type\tage" >GSE78845_metadata.txt
gzip -cd GSE78845_family.soft.gz | grep Sample_title | sed 's/^!Sample_title = //' >title.txt
gzip -cd GSE78845_family.soft.gz | grep celltype | sed 's/^!Sample_characteristics_ch1 = celltype identifier: //' >celltype.txt
gzip -cd GSE78845_family.soft.gz | grep "= age:" | sed 's/^!Sample_characteristics_ch1 = age: //' >age.txt
paste title.txt celltype.txt age.txt >>GSE78845_metadata.txt
```
#### 4. GSE95315 (Linnarsson's lab)
Metadata for cells were extracted from family soft file by the following commands.
```
echo -e "cell_id\tcell_type\tpostnatal_day" >GSE95315_metadata.txt
gzip -cd GSE95315_family.soft.gz | grep Sample_title | sed 's/^!Sample_title = //' >title.txt
gzip -cd GSE95315_family.soft.gz | grep "cell cluster:" | sed 's/^!Sample_characteristics_ch1 = cell cluster: //' >celltype.txt
gzip -cd GSE95315_family.soft.gz | grep "postnatal day:" | sed 's/^!Sample_characteristics_ch1 = postnatal day: //' >age.txt
paste title.txt celltype.txt age.txt >>GSE95315_metadata.txt
```
#### 5. GSE95752 (Linnarsson's lab)
Metadata for cells were extracted from family soft file by the following commands.
```
echo -e "cell_id\tcell_type\tpostnatal_day" >GSE95752_metadata.txt
gzip -cd GSE95752_family.soft.gz | grep Sample_title | sed 's/^!Sample_title = //' >title.txt
gzip -cd GSE95752_family.soft.gz | grep "cell cluster:" | sed 's/^!Sample_characteristics_ch1 = cell cluster: //' >celltype.txt
gzip -cd GSE95752_family.soft.gz | grep "postnatal day:" | sed 's/^!Sample_characteristics_ch1 = postnatal day: //' >age.txt
paste title.txt celltype.txt age.txt >>GSE95752_metadata.txt
```
#### 6. GSE81547
Metadata for cells were extracted from family soft file and expression data was concatanaged into a single matrix by the following commands.
```
# metadata
gzip -cd GSE81547_family.soft.gz | grep "SAMPLE = " | sed 's/^\^SAMPLE = //' >sample.txt
gzip -cd GSE81547_family.soft.gz | grep "donor_age:" | sed 's/^!Sample_characteristics_ch1 = donor_age: //' >age.txt
gzip -cd GSE81547_family.soft.gz | grep "inferred_cell_type:" | sed 's/^!Sample_characteristics_ch1 = inferred_cell_type: //' >celltype.txt
echo -e "cell_id\tage\tcell_type" >GSE81547_metadata.txt
paste sample.txt age.txt celltype.txt >> GSE81547_metadata.txt
rm sample.txt age.txt celltype.tt

# expression matrix
mkdir GSE81547_raw
mv GSE81547_RAW.tar GSE81547_raw
cd GSE81547_raw
tar -xvf GSE81547_RAW.tar
files=($(ls GSM*))
f=${files[0]}
pre=${f%%_*}
echo -e "gene\t$pre" >../GSE81547_count.txt
gzip -cd $f >>../GSE81547_count.txt
echo ${#files[@]}
for i in {1..2543}; do
        f=${files[$i]}
        pre=${f%%_*}
        echo $pre >tmp.txt
        gzip -cd $f | cut -f 2 >>tmp.txt
        paste ../GSE81547_count.txt tmp.txt >exp.txt
        mv exp.txt ../GSE81547_count.txt
done
cd ../
rm GSE81547_raw/*.gz
gzip GSE81547_count.txt
```
#### 7. GSE67835
Metadata for cells were extracted from family soft file and expression data was concatanaged into a single matrix by the following commands.
```
# metadata
echo -e "cell_id\tcell_type\tage" > GSE67835_metadata.txt
gzip -cd GSE67835_family.soft.gz | grep "SAMPLE = " | sed 's/^\^SAMPLE = //' >sample.txt
gzip -cd GSE67835_family.soft.gz | grep "= cell type:" | sed 's/!Sample_characteristics_ch1 = cell type: //' > celltype.txt
gzip -cd GSE67835_family.soft.gz | grep "= age: " | sed 's/!Sample_characteristics_ch1 = age: //'>age.txt
paste sample.txt celltype.txt age.txt >>GSE67835_metadata.txt

# expression matrix
mkdir GSE67835_raw
mv GSE67835_RAW.tar GSE67835_raw
cd GSE67835_raw
tar -xvf GSE67835_RAW.tar
files=($(ls GSM*))
f=${files[0]}
pre=${f%%_*}
echo -e "gene\t$pre" >../GSE67835_count.txt
gzip -cd $f >>../GSE67835_count.txt
echo ${#files[@]}
for i in {1..465}; do
	f=${files[$i]}
	pre=${f%%_*}
	echo $pre >tmp.txt
	gzip -cd $f | cut -f 2 >>tmp.txt
	paste ../GSE67835_count.txt tmp.txt >exp.txt
	mv exp.txt ../GSE67835_count.txt
done
cd ../
rm GSE67835_raw/*.gz
gzip GSE67835_count.txt
```
#### 8. GSE89232
Metadata for cells were extracted from family soft file by the following commands.
```
gzip -cd GSE89232_family.soft.gz | grep Sample_title | sed 's/^!Sample_title = //' >title.txt
gzip -cd GSE89232_family.soft.gz | grep "cell type:" | grep -v "(" | sed 's/!Sample_characteristics_ch1 = cell type: //' >celltype.txt
echo -e "cell_id\tcell_type" >GSE89232_celltype.txt
paste title.txt celltype.txt >>GSE89232_celltype.txt
```

#### 9. GSE97478
Metadata for cells were extracted from family soft file by the following commands.
```
gzip -cd GSE97478_family.soft.gz | grep Sample_title | sed 's/^!Sample_title = //' >title.txt
gzip -cd GSE97478_family.soft.gz | grep "cell type:" | grep -v "(" | sed 's/!Sample_characteristics_ch1 = cell type: //' >celltype.txt
echo -e "cell_id\tcell_type" >GSE97478_celltype.txt
paste title.txt celltype.txt >>GSE97478_celltype.txt
```

#### 10. GSE106707
Metadata for cells were extracted from family soft file by the following commands.
```
gzip -cd GSE106707_family.soft.gz | grep Sample_title | sed 's/^!Sample_title = //' >title.txt
gzip -cd GSE106707_family.soft.gz | grep "cell type:" | grep -v "(" | sed 's/!Sample_characteristics_ch1 = cell type: //' >celltype.txt
gzip -cd GSE106707_family.soft.gz | grep "postnatal days:" | grep -v "(" | sed 's/!Sample_characteristics_ch1 = postnatal days: //' >pd.txt
echo -e "cell_id\tcell_type\tpd" >GSE106707_celltype.txt
paste title.txt celltype.txt pd.txt >>GSE106707_celltype.txt
```

## Citation
K. Watanabe et al. Genetic mapping of cell type specificity for complex traits. <em>Nat. Commun.</em> **10**:3222. (2019).  
[https://www.nature.com/articles/s41467-019-11181-1](https://www.nature.com/articles/s41467-019-11181-1)


