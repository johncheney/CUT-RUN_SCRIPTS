#!/bin/bash
  

#SBATCH --job-name=fastqc
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8  
#SBATCH --mem-per-cpu=4G    
#SBATCH --time=6:00:00 


IN_DIR="../data/LIB240408AM" 
OUT_DIR="../results/fastqc"


for file in "$IN_DIR"/*.fastq.gz; do
	    if [ -r "$file" ]; then
	        read1="$file"
	        read2="${file/_R1_/_R2_}"

	        time fastqc -o "$OUT_DIR" -t 8 "$read1" "$read2"
	    else
	        echo "Error: $file does not exist or is not readable."

	    fi
done
