#!/bin/bash

#SBATCH -A ppi_concerto
#SBATCH -p slurm
#SBATCH -t 4-00:00:00
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -J carvme_gapfill
#SBATCH -e slurm-%j.err
#SBATCH -o slurm-%j.out

conda init
conda activate /people/anth445/miniconda3/carveme

MODEL="/rcfs/projects/ppi_concerto/best_assemblies/curtobacterium_CSC_009/csc009-gem/csc009/model.xml"
MEDIADB="/rcfs/projects/ppi_concerto/best_assemblies/curtobacterium_CSC_009/csc009-gem/csc009/data/media/CarveMeMinimalMediaFile.csv"
OUTPUT="/rcfs/projects/ppi_concerto/best_assemblies/curtobacterium_CSC_009/csc009-gem/csc009/model_gapfilled.xml"

gapfill $MODEL -m BL[dextrin],BL[pectin],BL[acgal],BL[abt__D],BL[arbt],BL[madg],BL[pala],BL[raffin],BL[salcn],BL[stys],BL[xylt],BL[gam],BL[Dara14lac] --mediadb $MEDIADB -o $OUTPUT --fbc2 -v
