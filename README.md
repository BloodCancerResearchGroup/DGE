### Pipeline for differential gene expression from bulk RNA-seq.

### PIPELINE OUTPUTS: 
    - alignment BAM files generated by STAR
    - Salmon quantification file
    - DESeq2 normalized counts file
    - DESeq2 results file
    - DESeq2 dds object for any other required analysis
    - Quality control of all samples made with MultiQC
 
### REQUIRED ADJUSTMENT IN nextflow.config
    - csv file containing metadata about samples (config - samplesCSV)
    - Genome fasta file
    - Salmon index folder (for more information check: https://salmon.readthedocs.io/en/latest/salmon.html#preparing-transcriptome-indices-mapping-based-mode – Preparing transcriptome indices)
    - Gencode annotation file (GTF)
    - STAR index (genome fasta file required, check https://physiology.med.cornell.edu/faculty/skrabanek/lab/angsd/lecture_notes/STARmanual.pdf for more info)
    - Conda and Nextflow installed
    - **DESeq2 design must be adjusted depending on the your experiment - lines 50, 51 and 69 in the bin/deseq2_create_objects.R** 

The pipeline can be run with "nextflow run DGE_workflow.nf -profile standard" 

Plans for future:
Make an option to automatically download and set up necessary references and indices.