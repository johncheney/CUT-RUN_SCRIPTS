#!/bin/bash

# Script: filter_and_process.sh
# Description: Filters SAM files, converts to BAM, applies filters based on suspect regions,
#              and processes fragments.

#SBATCH --job-name=sus_list
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

# see holding_dir/suslist2.sh for the OG script applied at first pass
# 7-23 Edit: Optimized this script to run array-style

###### STATIC #########################################    
# Input and output directories
SUSPECT_REGIONS="/home/users/cheneyjo/cheneyjo/references/suspect_lists/Nordin_Suspect_List.bed"
# INPUT_DIR="../results/picard_local/dedup_sam"
INPUT_DIR="../results/bowtie2_l/bam"
SL_OUTPUT_DIR="../results/suspect_list_filter_local"

# Assets
chromSize="/home/users/cheneyjo/cheneyjo/references/Mus_musculus/Ensembl/GRCm38/Sequence/WholeGenomeFasta/sizes.genome"

# Create necessary output sub-directories
# mkdir -p $SL_OUTPUT_DIR/{Nordin,sorted,bam,bed,cbed,fragment,counts,sorted2,sorted3}
mkdir -p $SL_OUTPUT_DIR/{sorted,bam,bed,Nordin,enrich,bedgraph,bed_bam,sorted_bedbam,bigwig,bedgraph_Nordin}



# # Iterate over SAM files in INPUT_DIR
# for SAM_FILE in "$INPUT_DIR"/*.sam; do
#     if [ -r "$SAM_FILE" ]; then
#         SAMPLE_NAME=$(basename "$SAM_FILE" .sam)

# 	# Sort the reads -- best practices and code will break otherwise
	# samtools sort -n -o $SL_OUTPUT_DIR/sorted/${SAMPLE_NAME}_sorted.sam $SAM_FILE
# else
#         echo "Error: No SAM files found in $INPUT_DIR"
#         exit 1                                                                                                                                           
#     fi      
# done


# #         # Convert to BAM and filter mapped reads
# for SAM_FILE in $SL_OUTPUT_DIR/sorted/*.sam; do
#     if [ -r "$SAM_FILE" ]; then
#         SAMPLE_NAME=$(basename "$SAM_FILE" .sam)
#         samtools view -hbS -F 0x04 $SL_OUTPUT_DIR/sorted/${SAMPLE_NAME}.sam > $SL_OUTPUT_DIR/bam/${SAMPLE_NAME}_mapped.bam
# else
#         echo "Error: No SAM files found in $INPUT_DIR"
#         exit 1                                                                                                                                           
#     fi      
# done

# # Fragment size enrichment 
# for BAM_FILE in $SL_OUTPUT_DIR/bam/*.bam; do
#     if [ -r "$BAM_FILE" ]; then
#         # Extract base filename without extension
#         SAMPLE_NAME=$(basename "$BAM_FILE" .bam)
        
#         # Extract common identifier for treatment replicate
#         common_identifier=$(echo "$SAMPLE_NAME" | cut -d '_' -f 1-4)
        
#         # Determine params based on common_identifier
#         if [[ "$common_identifier" == *"AR"* || "$common_identifier" == *"BRG"* ]]; then
#             params='<= 120 && abs($9) >= 10'
#         else
#             params='>= 150'
#         fi
        
#         echo "Processing $BAM_FILE with params: $params"
        
#         # Perform samtools and awk processing
#         # Save intermediate output after the awk command
#         samtools view -H "$BAM_FILE" > $SL_OUTPUT_DIR/bam/${SAMPLE_NAME}_header.sam
        
#         samtools view -h -q 30 -F 0xF04 "$BAM_FILE" | \
#             samtools fixmate - - | \
#             samtools view -f 0x3 - | \
#             awk -v params="$params" 'function abs(x){return ((x < 0) ? -x : x)} abs($9) { if (params) print }' \
#         > $SL_OUTPUT_DIR/bam/${SAMPLE_NAME}_filtered.sam
        
#         cat $SL_OUTPUT_DIR/bam/${SAMPLE_NAME}_header.sam $SL_OUTPUT_DIR/bam/${SAMPLE_NAME}_filtered.sam | \
#             samtools view -Sb - > $SL_OUTPUT_DIR/bam/${SAMPLE_NAME}_sorted.bam
        
#         # Index the sorted BAM file
#         samtools index $SL_OUTPUT_DIR/bam/${SAMPLE_NAME}_sorted.bam
        
#         # Optionally, remove intermediate files if desired
#         # rm "$OUTPUT_DIR/${SAMPLE_NAME}_header.sam" "$OUTPUT_DIR/${SAMPLE_NAME}_filtered.sam"
        
#     fi
# done

#         # Convert to BED
# for BAM_FILE in $SL_OUTPUT_DIR/bam/*.bam; do
#     if [ -r "$BAM_FILE" ]; then
#         SAMPLE_NAME=$(basename "$BAM_FILE" .bam)
#         bedtools bamtobed -i $SL_OUTPUT_DIR/bam/${SAMPLE_NAME}.bam -bedpe > $SL_OUTPUT_DIR/bed/${SAMPLE_NAME}.bed
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done

#         # Nordin Suspect list filter
# for BED_FILE in $SL_OUTPUT_DIR/bed/*.bed;  do
#     if [ -r "$BED_FILE" ]; then
#         SAMPLE_NAME=$(basename "$BED_FILE" .bed)
#         bedtools subtract -a $SL_OUTPUT_DIR/bed/${SAMPLE_NAME}.bed -b "$SUSPECT_REGIONS" > $SL_OUTPUT_DIR/Nordin/${SAMPLE_NAME}_filtered.bed
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done

# # IgG enrichment -- Thinking I want to eliminate this step entirely.. there isn't anywhere that this is done, I belive? 
# for BED_FILE in $SL_OUTPUT_DIR/Nordin/*.bed; do
#     if [ -r "$BED_FILE" ]; then
#         # Extract base filename without extension
#         SAMPLE_NAME=$(basename "$BED_FILE" .bed)
        
#         # Extract common identifier for treatment replicate
#         common_identifier=$(echo "$SAMPLE_NAME" | cut -d '_' -f 1-3)
#         # Find the corresponding IgG control file dynamically
#         IG_CONTROL_FILE=""
#         for CONTROL_FILE in $SL_OUTPUT_DIR/Nordin/*.bed; do
#             if [ -r "$CONTROL_FILE" ]; then
#                 CONTROL_NAME=$(basename "$CONTROL_FILE" .bed)
#                 if [ "$SAMPLE_NAME" != "$CONTROL_NAME" ] && [ "$(echo "$CONTROL_NAME" | cut -d '_' -f 1-3)" == "$common_identifier" ] && [[ "$CONTROL_NAME" == *"IgG"* ]]; then
#                     IG_CONTROL_FILE="$CONTROL_FILE"
#                     break
#                 fi
#             fi
#         done
        
#         # Check if the IgG control file exists and is readable
#         if [ -r "$IG_CONTROL_FILE" ]; then
#             echo "Processing $BED_FILE and $IG_CONTROL_FILE"
#             # Perform your seacr operations or any other processing here
#             bedtools subtract -a "$BED_FILE" -b "$IG_CONTROL_FILE" > $SL_OUTPUT_DIR/enrich/${SAMPLE_NAME}_enriched.bed  
# else
#             echo "Error: IgG control file not found for $SAMPLE_NAME"
#         fi
#     fi
# done

# # Convert bedfiles to bedgraphs (for Seacr)
# for BED_FILE in $SL_OUTPUT_DIR/enrich/*.bed; do #Uncomment for Loop
#     if [ -r "$BED_FILE" ]; then #uncomment for loop
#         # Extract base filename without extension
#         SAMPLE_NAME=$(basename "$BED_FILE" .bed) #Uncomment for loop
    #     SAMPLE_NAME=$(basename "$1" .bed)
    # bedtools genomecov -bg -i $SL_OUTPUT_DIR/enrich/sorted/${SAMPLE_NAME}.bed -g "$chromSize" > $SL_OUTPUT_DIR/bedgraph/${SAMPLE_NAME}.bedgraph
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done

# # Convert bed files to bam files (for GoPeaks)
# for BED_FILE in $SL_OUTPUT_DIR/enrich/*.bed; do
#     if [ -r "$BED_FILE" ]; then
#         SAMPLE_NAME=$(basename "$BED_FILE" .bed)
        # SAMPLE_NAME=$(basename "$1" .bed)
        # bedToBam -ubam -i $SL_OUTPUT_DIR/enrich/${SAMPLE_NAME}.bed -g $chromSize > $SL_OUTPUT_DIR/bed_bam/${SAMPLE_NAME}.bam 
 
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done


# SAMPLE_NAME=$(basename "$1" .bam)
# samtools sort -n -o $SL_OUTPUT_DIR/sorted_bedbam/${SAMPLE_NAME}_sorted.bam $SL_OUTPUT_DIR/bed_bam/${SAMPLE_NAME}.bam


# sort -n -o $SL_OUTPUT_DIR/sorted_bedbam/${SAMPLE_NAME}_sorted.bam $SL_OUTPUT_DIR/bed_bam/${SAMPLE_NAME}.bam

# processing beds from the enrich dir to sort them (bedgraph file generation was primed to take >> 24 hours)
# sort -k 1,1 -k2,2 $SL_OUTPUT_DIR/enrich/${SAMPLE_NAME}.bed > $SL_OUTPUT_DIR/enrich/sorted/${SAMPLE_NAME}_std.bed 

# SAMPLE_NAME=$(basename "$1" .bedgraph)
#     ~/ucsc/bedGraphToBigWig -unc $SL_OUTPUT_DIR/bedgraph/${SAMPLE_NAME}.bedgraph $chromSize $SL_OUTPUT_DIR/bigwig/${SAMPLE_NAME}.bigwig Dup_sorted_mapped_sorted_filtered_enriched_std.bigwig
    

    # # Convert bedfiles to bedgraphs (for Seacr) (the Nordin ones that aren't getting subtracted to be 0 line output files)
# for BED_FILE in $SL_OUTPUT_DIR/enrich/*.bed; do #Uncomment for Loop
#     if [ -r "$BED_FILE" ]; then #uncomment for loop
#         # Extract base filename without extension
#         SAMPLE_NAME=$(basename "$BED_FILE" .bed) #Uncomment for loop
        SAMPLE_NAME=$(basename "$1" .bed)
    bedtools genomecov -bg -i $SL_OUTPUT_DIR/Nordin/${SAMPLE_NAME}.bed -g "$chromSize" > $SL_OUTPUT_DIR/bedgraph_Nordin/${SAMPLE_NAME}.bedgraph
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done