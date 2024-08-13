#!/bin/bash
  

#SBATCH --job-name=homer
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=34G
#SBATCH --time=24:00:00

#### ASSETS ##### 

genome="/home/users/cheneyjo/cheneyjo/references/Mus_musculus/Ensembl/GRCm38/Sequence/WholeGenomeFasta/genome.fa"

# #seacr input dirs: 
INPUT_DIR="../results/homer/homer_peaks/seacr_non_stringent_S0_W4"
# # INPUT_DIR="../results/homer/homer_peaks/seacr_non_stringent_S9_W5"

OUTPUT_DIR="../results/homer/findmotifs/seacr_non_stringent_S0_W4"
# OUTPUT_DIR="../results/homer/findmotifs/seacr_non_stringent_S0_W4"

# GoPeaks input dirs: 

# INPUT_DIR="../results/homer/homer_peaks/gopeaks_S0_W4"
mkdir -p $OUTPUT_DIR

# findMotifsGenome.pl <peak/BED file> <genome> <output directory> -size # [options]

FILE="$1"
SAMPLE_NAME=$(basename "$1")  # Extract the sample name from the file

/home/users/cheneyjo/homer/bin/findMotifsGenome.pl $INPUT_DIR/$SAMPLE_NAME mm10 $OUTPUT_DIR/${SAMPLE_NAME} -size 200 -mask -p 8 
