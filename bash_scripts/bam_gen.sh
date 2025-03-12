#!/bin/bash

# this script generate bam files from fastq.gz file with prepared STAR index

# activate conda with ribo4, change conda path and env accordingly
source /home/zzz0054/miniconda3/etc/profile.d/conda.sh
conda activate ribo4

# cmd args
filename=$1 # could be a fastq.gz or fastq
align_index=$2
tmp_dir=$3
out_dir=$4
log_dir=$5
# tmp_clean_flag=$6

# get source file dir and basename
basename_s=$(basename "$filename")
dir_s=$(dirname "$filename")
basename_w=${basename_s%%.fastq.gz}

# create out_dir tmp_dir and log_dir
mkdir -p ${tmp_dir}
mkdir -p ${out_dir}
mkdir -p ${log_dir}

echo "---------------generating bam for ${basename_w}---------------"

# cutadapt with seq CTGTAGGCACCATCAAT, change other parameters accordingly
echo "---------------cutting---------------"
mkdir -p ${tmp_dir}/trimmed_out/
cutadapt -a CTGTAGGCACCATCAAT -e 0.2 -m 15 -M 60 --cores=64 -o ${tmp_dir}/trimmed_out/${basename_w}.fastq.gz $filename > ${log_dir}/${basename_s}_cutadapt.log

# length dist
mkdir -p ${out_dir}/${basename_w}/lengthDist
LengthDistribution -i $filename -o ${out_dir}/${basename_w}/lengthDist/ -f fastq

# process with STAR
echo "---------------mapping---------------"
STAR --runThreadN 12 --outFilterType Normal --outWigType wiggle --outWigStrand Stranded --outWigNorm RPM --alignEndsType EndToEnd --outFilterMismatchNmax 999 --readFilesCommand zcat --outFilterMultimapNmax 999 --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM GeneCounts --outSAMattributes All --limitBAMsortRAM 20587981295 --genomeDir ${align_index} --readFilesIn ${tmp_dir}/trimmed_out/${basename_s} --outFileNamePrefix ${tmp_dir}/${basename_w}_ | tee $log_dir/${basename_w}_star.txt

# sort and index this generated BAM file
echo "---------------sortint and indexing---------------"
samtools sort -T ${tmp_dir}/${basename_w}_Aligned.toTranscriptome.out.sorted.tmp -o ${out_dir}/${basename_w}_Aligned.toTranscriptome.out.sorted.bam ${tmp_dir}/${basename_w}_Aligned.toTranscriptome.out.bam
samtools index ${out_dir}/${basename_w}_Aligned.toTranscriptome.out.sorted.bam ## mapped to transcriptome

# if you want to do this, move Aligned.sortByCoord.out.sorted.bam to out dir, then mapped to genome
# samtools index ${out_dir}/${basename_w}_Aligned.sortByCoord.out.sorted.bam 
# if [ "$tmp_clean_flag" == "-d" ]; then
#     # Check if tmp_dir is defined and not empty, then clear the contents
#     if [[ -n "$tmp_dir" && -d "$tmp_dir" ]]; then
#         # Only delete the contents inside tmp_dir, but not tmp_dir itself
#         rm -rf "${tmp_dir:?}"/*  # Adding ':?' prevents accidental deletion if tmp_dir is empty
#     else
#         echo "Error: tmp_dir is not defined or does not exist."
#     fi

#     # Optionally, remove the tmp_dir itself if it is empty
#     if [[ -n "$tmp_dir" && -d "$tmp_dir" ]]; then
#         rmdir "$tmp_dir" || echo "Could not remove ${tmp_dir}: Directory not empty."
#     fi
# fi
