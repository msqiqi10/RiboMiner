#!/bin/bash

# this script performs feature analysis from ribominer
# run Data preparation from ribominer before this one
# run -m to get metaplots first and generate attr file
# strip 1st col in longest.transcripts.info.txt to get selected genes
# and this one works before the ttest

# activate conda with ribo4, change conda path and env accordingly
source /home/zzz0054/miniconda3/etc/profile.d/conda.sh
conda activate ribo4

# bash bash_scripts/feature_analysis.sh merged_out/0/AuxinC0TotalRNAR1_Aligned.toTranscriptome.out.sorted.bam ribominer_out/featureAnalysis ref/annot/ merged_out/0/attr.txt ref/longest.transcripts.info.txt AuxinA0FootprintR4__AuxinC0FootprintR4__AuxinC0TotalRNAR1 AuxinA0FootprintR4,AuxinC0FootprintR4,AuxinC0TotalRNAR1 ref/selected.transcripts.info.txt ref/ProteinCodingSeq_cds_sequences.fa

# cmd args
bam_filename=$1
out_dir=$2
annot_dir=$3
attributes_filename=$4
longest_transcripts_filename=$5
g=$6
r=$7
selected_transcripts_filename=$8
ProteinCodingSeq_cds_sequences_filename=$9

PlotRiboDensityAtEachKindAAOrCodon -i ${out_dir}/${basename_w}/RiboDensityAtEachKindAAOrCodon/RiboDensityAtEachKindAAOrCodon_all_codon_density.txt -o ${out_dir}/${basename_w}/RiboDensityAtEachKindAAOrCodon/RiboDensityAtEachKindAAOrCodon -g $g -r $r --level AA