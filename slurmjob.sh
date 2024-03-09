#!/usr/bin/bash
#SBATCH --job-name VariantCalling
#SBATCH --account OPEN-29-10
#SBATCH --partition qcpu
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 128
#SBATCH --time 16:00:00
#SBATCH --output slurm_log/slurm-%j.out
#SBATCH --mail-type END,FAIL
#SBATCH --mail-user P22016@student.osu.cz

cd /scratch/project/open-27-18/MRD_DGE
source activate nextflowenv
nextflow run runTrust.nf -profile standard_trust -resume