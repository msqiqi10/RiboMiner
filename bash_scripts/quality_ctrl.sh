#!/bin/bash

# this one generates mataplots
source /home/zzz0054/miniconda3/etc/profile.d/conda.sh
conda activate ribo4

# cmd args
bam_filename=$1
out_dir=$2
annot_dir=$3
gtf_filename=$4
ref_dir=$5

basename_s=$(basename "$bam_filename")
dir_s=$(dirname "$bam_filename")
basename_w=${basename_s%%_Aligned.toTranscriptome.out.sorted.bam}

# periodicity
mkdir -p ${out_dir}/${basename_w}/periodicity
Periodicity -i ${bam_filename} -a ${annot_dir} -o ${out_dir}/${basename_w}/periodicity/ -c $ref_dir/longest.transcripts.info.txt -L 20 -R 40

# metaplots
mkdir -p ${out_dir}/${basename_w}/metaplots
metaplots -a ${annot_dir} -r ${bam_filename} -o ${out_dir}/${basename_w}/metaplots/ -m 20 -M 45

# DNA contamination
mkdir -p ${out_dir}/${basename_w}/DNAContam
StatisticReadsOnDNAsContam -i  $bam_filename  -g $4  -o  ${out_dir}/${basename_w}/DNAContam