#!/usr/bin/bash
#SBATCH --job-name DGE
#SBATCH --account FTA-24-14
#SBATCH --partition qcpu
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 128
#SBATCH --time 24:00:00
#SBATCH --output slurm_log/slurm-%j.out
#SBATCH --mail-type END,FAIL
#SBATCH --mail-user daniel.bilek.s01@osu.cz


cd /scratch/project/open-27-18/MRD_DGE/
ml Anaconda3/2023.07-2
source activate nextflow
nextflow run deseq.nf -profile standard -resume