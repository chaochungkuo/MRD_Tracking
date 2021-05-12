# #!/bin/bash

# Load arguments
label=$1
stringarray=($2)
# echo $label
# echo ${stringarray[0]}
# echo ${stringarray[1]}
raw_fastq1=${stringarray[0]}
raw_fastq2=${stringarray[1]}

trim1=${DIR_trimed}/${label}_R1_val_1.fq.gz
trim2=${DIR_trimed}/${label}_R2_val_2.fq.gz

# cp $raw_fastq1 /media/work_disk/projects/AML/local/GEO_submission/
# cp $raw_fastq2 /media/work_disk/projects/AML/local/GEO_submission/

# Step 2: FASTQC on raw files
# mkdir -p ${DIR_output}/fastqc_raw
# echo $raw_fastq1
# tag=$(echo $raw_fastq1 | cut -d'_' -f 1,2)
# echo $tag
# if ls ${DIR_output}/fastqc_raw/${tag}*_fastqc.html 1> /dev/null 2>&1; then
# echo "FASTQC raw/t${label}"
# /usr/bin/fastqc -f fastq -o ${DIR_output}/fastqc_raw ${raw_fastq1}
# /usr/bin/fastqc -f fastq -o ${DIR_output}/fastqc_raw ${raw_fastq2}

# fi
#
# # Step 3: Trim the sequences
# if [ ! -f ${trim2} ]; then
# echo "TrimGalore\t${label}"
# ~/Apps/TrimGalore/trim_galore --paired -q ${TRIM_THRESHOLD} -o ${DIR_trimed} -basename ${label} $raw_fastq1 $raw_fastq2
# fi
#
# # Step 4: FASTQC on trimmed files
# mkdir -p ${DIR_output}/fastqc_trimmed
# if [ ! -f ${DIR_output}/fastqc_trimmed/${label}_R1_val_1_fastqc.html ]; then
# echo "FASTQC trimmed R1\t${label}"
# /usr/bin/fastqc -f fastq -o ${DIR_output}/fastqc_trimmed ${trim1}
# fi
#
# if [ ! -f ${DIR_output}/fastqc_trimmed/${label}_R2_val_2_fastqc.html ]; then
# echo "FASTQC trimmed R2\t${label}"
# /usr/bin/fastqc -f fastq -o ${DIR_output}/fastqc_trimmed ${trim2}
# fi

# # Step 5: Bismark
# mkdir -p ${DIR_output}/bismark/
# mkdir -p ${DIR_output}/bismark/${label}
#
# if [ ! -f ${DIR_output}/bismark/${label}/${label}_R1_val_1_bismark_bt2_pe.bam ]; then
#   echo "Bismark\t${label}"
#   ~/Apps/Bismark/bismark --bowtie2 --un --ambiguous \
#   -N ${BOWTIE2_SEED_MISMATCHES} \
#   -L ${BOWTIE2_SEED_LENGTH} \
#   -o ${DIR_output}/bismark/${label} ${DIR_reference} \
#   -1 ${trim1} \
#   -2 ${trim2}
# fi
#
# # Step 6: bismark_methylation_extractor
# if [ ! -f ${DIR_output}/bismark/${label}/CpG_context_${label}_R1_val_1_bismark_bt2_pe.txt.gz ]; then
#   echo "Bismark Methylation Extract\t${label}"
#   ~/Apps/Bismark/bismark_methylation_extractor -p --no_header --bedGraph --comprehensive --merge_non_CpG --gzip \
#   --genome_folder $REF_GENOME \
#   -o ${DIR_output}/bismark/${label} \
#   ${DIR_output}/bismark/${label}/${label}_R1_val_1_bismark_bt2_pe.bam
# fi

# Step 7: methpat
# Only python 2.7
# mkdir -p ${DIR_output}/bismark/res_methpat
if [ ! -f ${DIR_output}/bismark/res_methpat/${label}.tsv ]; then
  zcat ${DIR_output}/bismark/${label}/CpG_context_${label}_R1_val_1_bismark_bt2_pe.txt.gz > ${DIR_output}/bismark/${label}/CpG_context_${label}_R1_val_1_bismark_bt2_pe.txt
  mkdir -p ${DIR_output}/bismark/res_methpat
  methpat --amplicons ${FILE_amplicons} \
  --logfile ${DIR_output}/bismark/${label}/methpat.log \
  --html ${DIR_output}/bismark/${label}/methpat.html \
  ${DIR_output}/bismark/${label}/CpG_context_${label}_R1_val_1_bismark_bt2_pe.txt > ${DIR_output}/bismark/res_methpat/${label}.tsv
  rm ${DIR_output}/bismark/${label}/CpG_context_${label}_R1_val_1_bismark_bt2_pe.txt
fi
