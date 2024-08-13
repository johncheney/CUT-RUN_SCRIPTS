#!/bin/bash

#SBATCH --job-name=trimmo
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=12:00:00

# IN_DIR="../data/LIB240408AM"
IN_DIR="../data/total_input"
TRIMMED_DIR="../results/trimmo/trimmed"
UNTRIMMED_DIR="../results/trimmo/untrimmed"
ADAPTER_FILE="../../references/trimmomatic/TruSeq2-PE.fa"

LEADING="20"
TRAILING="20"
SLIDINGWINDOW="4:15"
MINLEN="25"


# for file in "$IN_DIR"/*_R1_001.fastq.gz; do
#     if [ -r "$file" ]; then
        # read1="$file"
        read1="$1"
        read2="${file/_R1_001/_R2_001}"

	echo $read1
	echo $read2
        time trimmomatic PE -threads 8 \
            "$read1" \
            "$read2" \
            "$TRIMMED_DIR/$(basename "$read1" .fastq.gz).trimmed.fastq" \
            "$UNTRIMMED_DIR/$(basename "$read1" .fastq.gz).untrimmed.fastq" \
            "$TRIMMED_DIR/$(basename "$read2" .fastq.gz).trimmed.fastq" \
            "$UNTRIMMED_DIR/$(basename "$read2" .fastq.gz).untrimmed.fastq" \
            ILLUMINACLIP:"$ADAPTER_FILE:2:15:4:4:TRUE" \
            LEADING:"$LEADING" \
            TRAILING:"$TRAILING" \
            SLIDINGWINDOW:"$SLIDINGWINDOW" \
            MINLEN:"$MINLEN"
#     fi
# done

