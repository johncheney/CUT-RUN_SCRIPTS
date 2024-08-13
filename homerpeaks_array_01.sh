#!/bin/bash
  

#SBATCH --job-name=homer
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=34G
#SBATCH --time=24:00:00

#seacr input dirs:
# INPUT_DIR="../results/merged/seacr_peaks/seacr_non_stringent_S0_W4"
# INPUT_DIR="../results/merged/seacr_peaks/seacr_non_stringent_S9_W5"
# OUTPUT_DIR="../results/homer/homer_peaks/seacr_non_stringent_S0_W4"
# OUTPUT_DIR="../results/homer/homer_peaks/seacr_non_stringent_S9_W5"

# Unmerged Attempt: 
INPUT_DIR="../results/unmerged/seacr/seacr_relaxed"
OUTPUT_DIR="../results/homer/homer_peaks/seacr_relaxed"

#GoPeaks Input Dirs: 

# INPUT_DIR="../results/merged/gopeaks_peaks/gopeaks_S0_W4"
# OUTPUT_DIR="../results/homer/homer_peaks/gopeaks_S0_W4"

mkdir -p $OUTPUT_DIR

FILE="$1"
SAMPLE_NAME=$(basename "$1" )  # Extract the sample name from the file

/home/users/cheneyjo/homer/bin/bed2pos.pl $INPUT_DIR/$SAMPLE_NAME > $OUTPUT_DIR/${SAMPLE_NAME}.homer.peak
