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


# get source file dir and basename
basename_s=$(basename "$bam_filename")
dir_s=$(dirname "$bam_filename")
basename_w=${basename_s%%_Aligned.toTranscriptome.out.sorted.bam}

# RiboDensityOfDiffFrames
mkdir -p ${out_dir}/${basename_w}/RiboDensityOfDiffFrames
RiboDensityOfDiffFrames -f ${attributes_filename} -c ${longest_transcripts_filename} -o ${out_dir}/${basename_w}/RiboDensityOfDiffFrames/  --plot yes

# RiboDensityForSpecificRegion
mkdir -p ${out_dir}/${basename_w}/RiboDensityForSpecificRegion
RiboDensityForSpecificRegion -f ${attributes_filename} -c ${longest_transcripts_filename} -o ${out_dir}/${basename_w}/RiboDensityForSpecificRegion/RiboDensityForSpecificRegion -U codon -M RPKM -L 1 -R 100

# KKK
mkdir -p ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs
## ribosome density at each tri-AA motif
RiboDensityAroundTripleteAAMotifs -o ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/KKK -M RPKM -l 100 -n 10 --table 1 -f ${attributes_filename} -c ${longest_transcripts_filename} -S ${selected_transcripts_filename} -F ${ProteinCodingSeq_cds_sequences_filename} --type2 KKK --type1 KK --mode single

## plot
PlotRiboDensityAroundTriAAMotifs -i ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/KKK_motifDensity_dataframe.txt -o ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/KKK -g $g -r $r --mode single
PlotRiboDensityAroundTriAAMotifs -i ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/KKK_motifDensity_dataframe.txt -o ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/KKK -g $g -r $r --mode mean

# DDD
mkdir -p ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs
## ribosome density at each tri-AA motif
RiboDensityAroundTripleteAAMotifs -o ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/DDD -M RPKM -l 100 -n 10 --table 1 -f ${attributes_filename} -c ${longest_transcripts_filename} -S ${selected_transcripts_filename} -F ${ProteinCodingSeq_cds_sequences_filename} --type2 DDD --type1 DD

## plot
PlotRiboDensityAroundTriAAMotifs -i ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/DDD_motifDensity_dataframe.txt -o ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/DDD -g $g -r $r --mode single
PlotRiboDensityAroundTriAAMotifs -i ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/DDD_motifDensity_dataframe.txt -o ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/DDD -g $g -r $r --mode mean

# PPP
mkdir -p ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs
## ribosome density at each tri-AA motif
RiboDensityAroundTripleteAAMotifs -o ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/PPP -M RPKM -l 100 -n 10 --table 1 -f ${attributes_filename} -c ${longest_transcripts_filename} -S ${selected_transcripts_filename} -F ${ProteinCodingSeq_cds_sequences_filename} --type2 PPP --type1 PP

## plot
PlotRiboDensityAroundTriAAMotifs -i ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/PPP_motifDensity_dataframe.txt -o ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/PPP -g $g -r $r --mode single
PlotRiboDensityAroundTriAAMotifs -i ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/PPP_motifDensity_dataframe.txt -o ${out_dir}/${basename_w}/RiboDensityAroundTripleteAAMotifs/PPP -g $g -r $r --mode mean

# RiboDensityAtEachKindAAOrCodon
mkdir -p ${out_dir}/${basename_w}/RiboDensityAtEachKindAAOrCodon

RiboDensityAtEachKindAAOrCodon -l 100 -n 10 --table 1 -M RPKM -f ${attributes_filename} -c ${longest_transcripts_filename} -o ${out_dir}/${basename_w}/RiboDensityAtEachKindAAOrCodon/RiboDensityAtEachKindAAOrCodon -S ${selected_transcripts_filename} -F ${ProteinCodingSeq_cds_sequences_filename}

PlotRiboDensityAtEachKindAAOrCodon -i ${out_dir}/${basename_w}/RiboDensityAtEachKindAAOrCodon/RiboDensityAtEachKindAAOrCodon_all_codon_density.txt -o ${out_dir}/${basename_w}/RiboDensityAtEachKindAAOrCodon/RiboDensityAtEachKindAAOrCodon -g $g -r $r --level AA

PlotRiboDensityAtEachKindAAOrCodon -i ${out_dir}/${basename_w}/RiboDensityAtEachKindAAOrCodon/RiboDensityAtEachKindAAOrCodon_all_codon_density.txt -o ${out_dir}/${basename_w}/RiboDensityAtEachKindAAOrCodon/RiboDensityAtEachKindAAOrCodon -g $g -r $r --level codon

# RiboDensityAtEachKindAAOrCodonEachKindAA
mkdir -p ${out_dir}/${basename_w}/RiboDensityAtEachKindAAOrCodonEachKindAA/
RiboDensityAtEachKindAAOrCodon -f ${attributes_filename} -c ${longest_transcripts_filename} -o ${out_dir}/${basename_w}/RiboDensityAtEachKindAAOrCodonEachKindAA/RiboDensityAtEachKindAAOrCodonEachKindAA -S ${selected_transcripts_filename} -F ${ProteinCodingSeq_cds_sequences_filename} -u 1 -d 50 -M RPKM -l 100 -n 10 --table 1

# pasuing score
mkdir -p ${out_dir}/${basename_w}/PausingScore
PausingScore -M RPKM -l 100 -n 10 --table 1 -M RPKM -f ${attributes_filename} -c ${longest_transcripts_filename} -o ${out_dir}/${basename_w}/PausingScore/ -S ${selected_transcripts_filename} -F ${ProteinCodingSeq_cds_sequences_filename} 

# process pausing score TODO
find /path/to/your/dir -type f | xargs -I {} ProcessPausingScore -i {} -o ${out_dir}/${basename_w}/PausingScoreProcess -g $g -r $r --mode raw --ratio_filter 2 --pausing_score_filter 10

# RPFdist
mkdir -p ${out_dir}/${basename_w}/

RPFdist -f ${attributes_filename} -c ${longest_transcripts_filename} -o ${out_dir}/${basename_w}/ -S ${selected_transcripts_filename} -M RPKM -l 100 -n 10 -m 1 -e 5
