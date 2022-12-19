# cell_types = ["Astro"]
# stages = ["Adult"]
level1_cell_types = ['PN', 'IN', 'Non-Neu']
level2_cell_types = ['L4_RORB', 'L2-3_CUX2', 'SST', 'Astro', 'L5-6_TLE4', 'L5-6_THEMIS', 'VIP', 'OPC', 'PV', 'PV_SCUBE3', 'ID2', 'Oligo', 'LAMP5_NOS1', 'Micro', 'Vas', 'MGE_dev', 'PN_dev', 'CGE_dev']
stages = ['Adult', 'Infancy', 'Adolescence', 'Fetal', 'Childhood', 'Neonatal']
level3_cell_types = ['L4_RORB_dev-2', 'L2-3_CUX2_dev-2', 'SST_CALB1_dev', 'Astro_dev-2', 'L5-6_TLE4_SCUBE1', 'L5-6_THEMIS_dev-2', 'VIP_ABI3BP', 'SST_STK32A', 'OPC_dev', 'SST_ADGRG6_dev', 'VIP_CHRM2', 'PV_dev', 'SST_BRINP3', 'PV_SCUBE3_dev', 'CCK_SYT6', 'ID2_dev', 'L5-6_TLE4_HTR2C', 'L4_RORB_MME', 'L5-6_TLE4_SORCS1', 'Astro_dev-1', 'L2-3_CUX2_dev-3', 'VIP_HS3ST3A1', 'LAMP5_NDNF', 'SST_B3GAT2', 'OPC_MBP', 'Astro_SLC1A2_dev', 'LAMP5_NOS1', 'SST_NPY', 'VIP_ADAMTSL1', 'VIP_DPP6', 'L2-3_CUX2_dev-6', 'PV_SULF1_dev', 'SST_TH', 'VIP_CRH', 'VIP_PCDH20', 'VIP_KIRREL3', 'L4_RORB_dev-1', 'L5-6_TLE4_dev', 'CCK_RELN', 'Astro_GFAP', 'LAMP5_CCK', 'Astro_dev-4', 'OPC', 'Micro', 'Vas_CLDN5', 'PV_SST', 'MGE_dev-1', 'L5-6_THEMIS_dev-1', 'ID2_CSMD1', 'PV_SULF1', 'L2_CUX2_LAMP5_dev', 'CCK_SORCS1', 'SST_ADGRG6', 'L5-6_THEMIS_NTNG2', 'L2-3_CUX2_dev-5', 'MGE_dev-2', 'PV_WFDC2', 'VIP_dev', 'SST_CALB1', 'L5-6_THEMIS_CNR1', 'Astro_SLC1A2', 'L2-3_CUX2_dev-1', 'L4_RORB_LRRK1', 'L2_CUX2_LAMP5', 'L4_RORB_MET', 'L3_CUX2_PRSS12', 'PV_SCUBE3', 'BKGR_NRGN', 'Oligo_mat', 'Micro_out', 'Oligo-4', 'Oligo-1', 'Vas_TBX18', 'Oligo-2', 'Oligo-5', 'L2-3_CUX2_dev-fetal', 'Oligo-3', 'L4_RORB_dev-fetal', 'L2-3_CUX2_dev-4', 'Vas_PDGFRB', 'PN_dev', 'CGE_dev', 'Astro_dev-3', 'Oligo-7', 'Astro_dev-5', 'Oligo-6']

rule all:
    input:
        expand("/home/tphung/data/herring_human_pfc/processed/level1/{stage}/{ct}_{stage}_mean_magma_input.txt", ct=level1_cell_types, stage=stages) #level1
        expand("/home/tphung/data/herring_human_pfc/processed/level2/{stage}/{ct}_{stage}_mean_magma_input.txt", ct=level2_cell_types, stage=stages) #level2
        expand("/home/tphung/data/herring_human_pfc/processed/level3/{stage}/{ct}_{stage}_mean_magma_input.txt", ct=level3_cell_types, stage=stages) #level3

rule process_herring_level1:
    input:
        count_fn = "/home/tphung/data/herring_human_pfc/level1/{ct}_{stage}.csv",
        ensg = "/home/tphung/data/reference/ENSG.genes.txt"
    output:
        mean = "/home/tphung/data/herring_human_pfc/processed/level1/{stage}/{ct}_{stage}_mean_magma_input.txt"
    params:
        celltype = "{ct}"
    shell:
        """
        Rscript calc_mean_pergene_percelltype_herring.r {input.count_fn} {params.celltype} {input.ensg} {output.mean}
        """

rule process_herring_level2:
    input:
        count_fn = "/home/tphung/data/herring_human_pfc/level2/{ct}_{stage}.csv",
        ensg = "/home/tphung/data/reference/ENSG.genes.txt"
    output:
        mean = "/home/tphung/data/herring_human_pfc/processed/level2/{stage}/{ct}_{stage}_mean_magma_input.txt"
    params:
        celltype = "{ct}"
    shell:
        """
        Rscript calc_mean_pergene_percelltype_herring.r {input.count_fn} {params.celltype} {input.ensg} {output.mean}
        """

rule process_herring_level3:
    input:
        count_fn = "/home/tphung/data/herring_human_pfc/level3/{ct}_{stage}.csv",
        ensg = "/home/tphung/data/reference/ENSG.genes.txt"
    output:
        mean = "/home/tphung/data/herring_human_pfc/processed/level3/{stage}/{ct}_{stage}_mean_magma_input.txt"
    params:
        celltype = "{ct}"
    shell:
        """
        Rscript calc_mean_pergene_percelltype_herring.r {input.count_fn} {params.celltype} {input.ensg} {output.mean}
        """
