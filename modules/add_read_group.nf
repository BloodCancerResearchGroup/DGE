process ADD_READ_GROUP {
    label "low"
    tag "${sample_ID}"    
    publishDir(path: "${params.output}${sample_ID}/BAM_files", mode: 'copy', overwrite: 'true')

    input:
    tuple val(sample_ID), path(BAM_FILE), path(BAM_INDEX)

    output:
    tuple val(sample_ID), path("${sample_ID}_rgAdded_aligned.sortedByCoord.out.bam"), path("${sample_ID}_rgAdded_aligned.sortedByCoord.out.bam.bai"), emit: bamrg
    path "versions.yml", emit: versions

    """
    picard AddOrReplaceReadGroups --RGLB lib1 --RGPL illumina --RGPU ${sample_ID} -SM ${sample_ID} \
    --VALIDATION_STRINGENCY LENIENT -I ${BAM_FILE} -O ${sample_ID}_rgAdded_aligned.sortedByCoord.out.bam 
    
    samtools index ${sample_ID}_rgAdded_aligned.sortedByCoord.out.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
    picard: \$(picard AddOrReplaceReadGroups --version 2>&1 | grep -o 'Version:.*' | cut -f2- -d:)
    samtools: \$(echo \$(gawk --version) | sed "s/^. *GNU Awk //; s/, .*\$//")
    END_VERSIONS
    """
}