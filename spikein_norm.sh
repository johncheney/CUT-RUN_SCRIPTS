#!/bin/bash

#SBATCH --job-name=spikein_norm
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

#OUTPUT_DIR="../results/spikein_calibration"
OUTPUT_DIR="../results/rpm_calibration"
INPUT_DIR="../results/suspect_list_filter/fragment"
#INPUT_DIR="../results/suspect_list_filter/bed"
chromSize="/home/users/cheneyjo/cheneyjo/references/Mus_musculus/Ensembl/GRCm38/Sequence/WholeGenomeFasta/sizes.genome"
BT2_SUM_DIR="/home/users/cheneyjo/cheneyjo/cutandrun/results/bowtie2_spikein/summary_spikein"

mkdir -p $OUTPUT_DIR

## Iterate over each .seqDepth file in BT2_SUM_DIR
for file_set1 in "${BT2_SUM_DIR}"/*.seqDepth; do
    if [ -r "$file_set1" ]; then
        # Extract the common identifier from file_set1
        base1=$(basename "${file_set1}")
        common_identifier1=$(echo "${base1}" | cut -d '_' -f 1-4)
        
        # Echo base1 and common_identifier1
        #echo "base1: ${base1}"

        # Check if there's a corresponding .bed file in INPUT_DIR
        for file_set2 in "${INPUT_DIR}"/*.bed; do
            if [ -r "$file_set2" ]; then
                # Extract the common identifier from file_set2
                base2=$(basename "${file_set2}")
                common_identifier2=$(echo "${base2}" | cut -d '_' -f 1-4)

                # Echo base2 and common_identifier2
                #echo "base2: ${base2}"

                # Compare common identifiers (ignoring temporary files)
                if [[ "${common_identifier1}" == "${common_identifier2}" && "${file_set2}" != *"tmp"* ]]; then
                    echo "Processing ${file_set1} and ${file_set2}"

                    # Calculate scaling factor (assuming seqDepth is the content of file_set1)
                    seqDepth=$(cat "${file_set1}")
                    scale_factor=$(echo "100000 / $seqDepth" | bc -l)

                    # echo "common_identifier1: ${common_identifier1}"
                    # echo "common_identifier2: ${common_identifier2}"
                    echo "scale_factor: ${scale_factor}"
                    # Perform bedtools operation (commented out)
                     bedtools genomecov -bg -scale "$scale_factor" -i "$file_set2" -g "$chromSize" > "${OUTPUT_DIR}"/${base2}_bowtie2.fragments.normalized.bedgraph
                    
                    # Echo the scale_factor
                fi
            fi
        done
    fi
done
