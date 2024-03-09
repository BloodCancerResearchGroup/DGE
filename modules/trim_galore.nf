process TRIM_GALORE {
    label "trim_galore"
    tag "${sample_ID}"

    input:
    tuple val(sample_ID), val(fq1), val(fq2)

    output:
    tuple val(sample_ID), path("${sample_ID}_1_val_1.fq.gz"), path("${sample_ID}_2_val_2.fq.gz"), emit: fqs
    tuple val(sample_ID), path("${sample_ID}_1.fastq.gz_trimming_report.txt"), path("${sample_ID}_2.fastq.gz_trimming_report.txt"), emit: trim_galore_report
    tuple val(sample_ID), path("${sample_ID}_fastqc"), emit: fastqc
    path "versions.yml", emit: versions  


    script:
    """
    mkdir ${sample_ID}_fastqc
    trim_galore -q 20 --clip_R2 3 --illumina --paired ${fq1} ${fq2} --cores ${task.cpus} --fastqc_args "--outdir ${sample_ID}_fastqc"


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        trimgalore: \$(echo \$(trim_galore --version 2>&1) | sed 's/^.*version //; s/Last.*\$//')
        cutadapt: \$(cutadapt --version)
    END_VERSIONS
    """
}
