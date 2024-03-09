process SALMON {
    label "medium"
    tag "${sample_ID}"
    publishDir(path: "${params.output}${sample_ID}", mode: 'copy', overwrite: 'true')

    input:
    tuple val(sample_ID), path(fq1noRNA), path(fq2noRNA)
    path salmon_index

    output:
    tuple val(sample_ID), path("${sample_ID}_salmon"), emit: salmon_quant
    path "versions.yml", emit: versions

    """
    salmon quant -i ${salmon_index} --gcBias \
    --reduceGCMemory --seqBias -l A -1 ${fq1noRNA} -2 ${fq2noRNA} \
    --validateMappings --writeUnmappedNames -p ${task.cpus} -o ${sample_ID}_salmon


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
    \$(salmon --version)
    END_VERSIONS
    """
}
