#!/bin/bash

# Script: filter_and_process.sh
# Description: Filters SAM files, converts to BAM, applies filters based on suspect regions,
#              and processes fragments.

#SBATCH --job-name=sus_list
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

# Input and output directories
SUSPECT_REGIONS="/home/users/cheneyjo/cheneyjo/references/suspect_lists/Nordin_Suspect_List.bed"
INPUT_DIR="../results/picard_local/dedup_sam"
SL_OUTPUT_DIR="../results/suspect_list_filter_local"

# Create necessary output sub-directories
mkdir -p $SL_OUTPUT_DIR/{MAPQ,Nordin,sorted,bam,bed,cbed,fragment,counts,sorted2,sorted3}

# Parameters
minQualityScore=0
binLen=500

# Iterate over SAM files in INPUT_DIR
for SAM_FILE in "$INPUT_DIR"/*.sam; do
    if [ -r "$SAM_FILE" ]; then
        SAMPLE_NAME=$(basename "$SAM_FILE" .sam)

	# Sort them again

	samtools sort -n -o $SL_OUTPUT_DIR/sorted/${SAMPLE_NAME}_sorted.sam $SAM_FILE

else
        echo "Error: No SAM files found in $INPUT_DIR"
        exit 1                                                                                                                                           
    fi      
done


# MAPQ Filter Step
# for SAM_FILE in $SL_OUTPUT_DIR/sorted/*.sam; do
#     if [ -r "$SAM_FILE" ]; then
#         SAMPLE_NAME=$(basename "$SAM_FILE" .sam)
# # Next line was the OG Code; I am just trying to reroute them to the MAPQ Folder for simplicity here
#         # samtools view -h -q $minQualityScore $SL_OUTPUT_DIR/sorted/${SAMPLE_NAME}.sam > $SL_OUTPUT_DIR/MAPQ/${SAMPLE_NAME}_qualityScore${minQualityScore}.sam
#         samtools view -h $SL_OUTPUT_DIR/sorted/${SAMPLE_NAME}.sam > $SL_OUTPUT_DIR/MAPQ/${SAMPLE_NAME}_qualityScore${minQualityScore}.sam
# else
#         echo "Error: No SAM files found in $INPUT_DIR"
#         exit 1                                                                                                                                           
#     fi      
# done

#         # Convert to BAM and filter mapped reads
for SAM_FILE in $SL_OUTPUT_DIR/MAPQ/*.sam; do
    if [ -r "$SAM_FILE" ]; then
        SAMPLE_NAME=$(basename "$SAM_FILE" .sam)
        samtools view -hbS -F 0x04 $SL_OUTPUT_DIR/MAPQ/${SAMPLE_NAME}.sam > $SL_OUTPUT_DIR/bam/${SAMPLE_NAME}_mapped.bam
else
        echo "Error: No SAM files found in $INPUT_DIR"
        exit 1                                                                                                                                           
    fi      
done


### There is a need to resort the .bam files somewhere after this step, otherwise we lose too many reads i.e.: I have 17244 of these lines 
# # *****WARNING: Query VH01806:12:AAFH7C2M5:1:2611:39609:52779 is marked as paired, but its mate does not occur next to it in your BAM file.  Skipping. 
# *****WARNING: Query VH01806:12:AAFH7C2M5:1:2611:41768:29000 is marked as paired, but its mate does not occur next to it in your BAM file.  Skipping. 

# Iterate over BAM files in Nordin
# for BAM_FILE in "$SL_OUTPUT_DIR/bam"/*.bam; do
#     if [ -r "$BAM_FILE" ]; then
#         SAMPLE_NAME=$(basename "$BAM_FILE" .bam)

# 	# Sort them again

# 	samtools sort -n -o $SL_OUTPUT_DIR/sorted2/${SAMPLE_NAME}.bam $BAM_FILE

# else
#         echo "Error: No SAM files found in $INPUT_DIR"
#         exit 1                                                                                                                                           
#     fi      
# done


        # Convert to BED
for BAM_FILE in $SL_OUTPUT_DIR/sorted2/*.bam; do
    if [ -r "$BAM_FILE" ]; then
        SAMPLE_NAME=$(basename "$BAM_FILE" .bam)
        bedtools bamtobed -i $SL_OUTPUT_DIR/sorted2/${SAMPLE_NAME}.bam -bedpe > $SL_OUTPUT_DIR/bed/${SAMPLE_NAME}_filtered.bed

else
echo "Error: No SAM files found in $INPUT_DIR"
exit 1                                                                                                                                           
fi      
done

        # Nordin Suspect list filter
        # This code needs fixing -- bedtools subtract only accepts BED/GFF/VCF files 
for BED_FILE in $SL_OUTPUT_DIR/bed/*.bed;  do
    if [ -r "$BED_FILE" ]; then
        SAMPLE_NAME=$(basename "$BED_FILE" .bed)
        bedtools subtract -a $SL_OUTPUT_DIR/bed/${SAMPLE_NAME}.bed -b "$SUSPECT_REGIONS" > $SL_OUTPUT_DIR/Nordin/${SAMPLE_NAME}_filtered.bed
else
echo "Error: No SAM files found in $INPUT_DIR"
exit 1                                                                                                                                           
fi      
done


        # Keep read pairs on the same chromosome and < 1000bp apart
# for BED_FILE in $SL_OUTPUT_DIR/Nordin/*.bed; do
#     if [ -r "$BED_FILE" ]; then
#         SAMPLE_NAME=$(basename "$BED_FILE" .bed)
#         awk '$1==$4 && $6-$2 < 1000 {print $0}' $SL_OUTPUT_DIR/bed/${SAMPLE_NAME}.bed > $SL_OUTPUT_DIR/cbed/${SAMPLE_NAME}_clean.bed

# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done
#         # Extract fragment related columns
# for BED_FILE in $SL_OUTPUT_DIR/cbed/*.bed; do
#     if [ -r "$BED_FILE" ]; then
#         SAMPLE_NAME=$(basename "$BED_FILE" .bed)
#         cut -f 1,2,6 $SL_OUTPUT_DIR/cbed/${SAMPLE_NAME}.bed | sort -k1,1 -k2,2n -k3,3n > $SL_OUTPUT_DIR/fragment/${SAMPLE_NAME}.bed
 
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done


#         # Bin fragments
# for BED_FILE in $SL_OUTPUT_DIR/fragment/*.bed;  do
#     if [ -r "$BED_FILE" ]; then
#         SAMPLE_NAME=$(basename "$BED_FILE" .bed)
#         awk -v w=$binLen '{print $1, int(($2 + $3)/(2*w))*w + w/2}' $SL_OUTPUT_DIR/fragment/${SAMPLE_NAME}.bed | \
#             sort -k1,1V -k2,2n | uniq -c | awk -v OFS="\t" '{print $2, $3, $1}' | sort -k1,1V -k2,2n > $SL_OUTPUT_DIR/counts/${SAMPLE_NAME}_fragmentsCount.bin${binLen}.bed
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done
