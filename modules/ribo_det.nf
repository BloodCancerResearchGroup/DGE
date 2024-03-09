process RIBO_DET {
    label "ribo_det"
    tag "${sample_ID}"

    input:
    tuple val(sample_ID), path(fq1), path(fq2)

    output:
    tuple val(sample_ID), path("${sample_ID}_noRiboFq1.fastq.gz"), path("${sample_ID}_noRiboFq2.fastq.gz"), emit: fqs
    tuple val(sample_ID), path("${sample_ID}_log.txt"), emit: ribo_det_log
    path "versions.yml", emit: versions
    
    """
    ribodetector_cpu -t ${task.cpus} -l 150 --chunk_size 1800 -i ${fq1} ${fq2} -e rrna \
    -o ${sample_ID}_noRiboFq1.fastq.gz ${sample_ID}_noRiboFq2.fastq.gz \
    -r ${sample_ID}_RiboFq1.fastq ${sample_ID}_RiboFq2.fastq \
    --log ${sample_ID}_log.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
    \$(ribodetector --version)
    END_VERSIONS
    """
}