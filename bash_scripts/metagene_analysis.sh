#!/bin/bash

# this script performs metagene analysis from ribominer
# run Data preparation from ribominer before this one
# run -m to get metaplots first and generate attr file
# strip 1st col in longest.transcripts.info.txt to get selected genes

# bash bash_scripts/metagene_analysis.sh merged_out/0/AuxinC0TotalRNAR1_Aligned.toTranscriptome.out.sorted.bam ribominer_out/metagene ref/annot/ merged_out/0/attr.txt ref/longest.transcripts.info.txt AuxinA0FootprintR4__AuxinC0FootprintR4__AuxinC0TotalRNAR1 AuxinA0FootprintR4,AuxinC0FootprintR4,AuxinC0TotalRNAR1

# activate conda with ribo4, change conda path and env accordingly
source /home/zzz0054/miniconda3/etc/profile.d/conda.sh
conda activate ribo4

# cmd args
bam_filename=$1
out_dir=$2
annot_dir=$3
attributes_filename=$4
longest_transcripts_filename=$5
r=$6
g=$7

# -g GROUP_NAME, --group=GROUP_NAME Group name of each group separated by comma. e.g. 'si- control,si-eIF3e'
# -r REPLICATE_NAME, --replicate=REPLICATE_NAME Replicate name of each group separated by comma, and group separated by "__".e.g. 'si_3e_1_80S,si_3e_2_80S__si_cttl_1_80S,si_ctrl_2_80S'

# get source file dir and basename
basename_s=$(basename "$bam_filename")
dir_s=$(dirname "$bam_filename")
basename_w=${basename_s%%_Aligned.toTranscriptome.out.sorted.bam}

mkdir -p ${out_dir}/${basename_w}/MetageneAnalysisForTheWholeRegions
MetageneAnalysisForTheWholeRegions -f ${attributes_filename} -c ${longest_transcripts_filename} -o ${out_dir}/${basename_w}/MetageneAnalysisForTheWholeRegions/MetageneAnalysisForTheWholeRegions -b 15,90,15 -l 100 -n 10 -m 1 -e 5

PlotMetageneAnalysisForTheWholeRegions -i ${out_dir}/${basename_w}/MetageneAnalysisForTheWholeRegions/MetageneAnalysisForTheWholeRegions_scaled_density_dataframe.txt -o ${out_dir}/${basename_w}/MetageneAnalysisForTheWholeRegions/ -g $g -r $r  -b 15,90,15 --mode mean --xlabel-loc -0.4

mkdir -p ${out_dir}/${basename_w}/MetageneAnalysis
## metagene analysis
MetageneAnalysis -f ${attributes_filename} -c ${longest_transcripts_filename} -o ${out_dir}/${basename_w}/MetageneAnalysis/MetageneAnalysis -U codon -M RPKM -u 0 -d 500 -l 100 -n 10 -m 1 -e 5 --norm yes -y 100 --CI 0.95 --type CDS

## plot
PlotMetageneAnalysis -i ${out_dir}/${basename_w}/MetageneAnalysis/MetageneAnalysis_dataframe.txt  -o ${out_dir}/${basename_w}/MetageneAnalysis/MetageneAnalysisPlot -u 0 -d 500 -g $g -r $r -U codon --CI 0.95 --mode mean

mkdir -p ${out_dir}/${basename_w}/MetageneAnalysisUTR
##  metagene analysis for UTR
MetageneAnalysis -f ${attributes_filename} -c ${longest_transcripts_filename} -o ${out_dir}/${basename_w}/MetageneAnalysisUTR/MetageneAnalysisUTR -U nt -M RPKM -u 100 -d 100 -l 100 -n 10 -m 1 -e 5 --norm yes -y 100 --CI 0.95 --type UTR

PlotMetageneAnalysis -i ${out_dir}/${basename_w}/MetageneAnalysisUTR/MetageneAnalysisUTR_dataframe.txt  -o ${out_dir}/${basename_w}/MetageneAnalysisUTR/MetageneAnalysisUTR -u 100 -d 100 -g $g -r $r -U nt --CI 0.95


mkdir -p ${out_dir}/${basename_w}/PolarityCalculation
## polarity calculation
PolarityCalculation -f ${attributes_filename} -c ${longest_transcripts_filename} -o ${out_dir}/${basename_w}/PolarityCalculation/PolarityCalculation111 -n 64