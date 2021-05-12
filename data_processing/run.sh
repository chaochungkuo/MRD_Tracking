#!/bin/bash

##############################################################
## Parameters
##############################################################
# Trimming
export TRIM_THRESHOLD="30"

# Bismark
export BOWTIE2_SEED_MISMATCHES="0"
export BOWTIE2_SEED_LENGTH="20"
# export BISMARCK_METHYLATION_CUTOFF="5"
# N_CORES="8"

##############################################################
## Paths
##############################################################
export DIR_output="./processed_data"
export DIR_config="/projects/Track_AML/config"
export DIR_script="/projects/Track_AML/scripts"
export DIR_fastqc="/media/work_disk/projects/AML/data/fastq"
export DIR_trimed="${DIR_output}/trimmed_sequences_${TRIM_THRESHOLD}"
export DIR_reference="./reference"
# export DIR_reference="/home/joseph/rgtdata/hg19"

# Files
# export REF_GENOME="/home/joseph/rgtdata/hg19/genome_hg19.fa"
export REF_GENOME="./reference/Genome_METB_NN.fa"
export FILE_sample_table="/projects/AML/data/samples_overview.xlsx"
export FILE_amplicons="./reference/amplicons.tsv"

mkdir -p $DIR_output
mkdir -p $DIR_trimed
mkdir -p ${DIR_output}/bismark202104/

###########################################################################
# Convert xlsx to csv
# ssconvert ${FILE_sample_table} samples_20210427.csv
# Extract the table for FASTAQ file name mapping to sample ID
sed 's/\,/\t/g' samples_20210427.csv | sed 's/\"//g' | cut -f 2,9  | tail -n +2 > file_mapping.txt

###########################################################################
# Process each sample
while IFS=, read c;do
    # echo $c
    var1=$(echo $c | cut -f1 -d " ")
    var2=$(echo $c | cut -f2 -d " ")
    # echo $var1
    # echo $var2
    # echo ${var1} "${DIR_fastqc}/${var2}"
    # if [ $c2 = "AC" ]; then
    bash process_each_sample.sh ${var1} "${DIR_fastqc}/${var2}"
    # fi
done < file_mapping.txt

# rm file_mapping.txt
