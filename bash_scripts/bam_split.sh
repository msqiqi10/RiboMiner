#!/bin/bash

# this script generate bam files from splited fastq.gz file with prepared STAR index

# activate conda with ribo4, change conda path and env accordingly
source /home/zzz0054/miniconda3/etc/profile.d/conda.sh
conda activate ribo4

# Specify the directory path
directory=$1
out_dir=$2
log_dir=$3

mkdir -p ${out_dir}

# Change to the specified directory
FILES=$(find $directory -type f -name "*.fastq.gz")
extract_part() {
    local filename=$1
    local part=${filename#*.}
    part=${part%%.*}
    echo $part
}

cwd=$(pwd)

# Iterate through all files in the directory
for file in $FILES; do
    # Check if it's a file (not a directory)
    if [ -f "$file" ]; then
        echo "Processing file: $file"

        # get source file dir and basename
        basename_s=$(basename "$file")
        dir_s=$(dirname "$file")
        basename_w=${basename_s%%.fastq.gz}
        part=$(extract_part "$file")

        echo "---------------------------------"
        echo "${part}"
        echo "${basename_w}"
        echo "${basename_s}"
        echo "---------------------------------"

        mkdir -p ${out_dir}/${part}/

        STAR --runThreadN 64 --outFilterType Normal --outWigType wiggle --outWigStrand Stranded --outWigNorm RPM --alignEndsType EndToEnd --outFilterMismatchNmax 999 --readFilesCommand zcat --outFilterMultimapNmax 999 --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM GeneCounts --outSAMattributes All --limitBAMsortRAM 20587981295 --genomeDir ref/STAR_genome_index --readFilesIn $file --outFileNamePrefix ${out_dir}/${part}/ | tee $log_dir/${basename_w}_star.txt
        
        echo "---"
    fi
done
        