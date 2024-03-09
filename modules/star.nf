process STAR {
    label "star"
    tag "${sample_ID}"

    input:
    tuple val(sample_ID), path(fq1), path(fq2)
    path star_index

        
    output:
    tuple val(sample_ID), path("${sample_ID}_Aligned.sortedByCoord.out.bam"), path("${sample_ID}_Aligned.sortedByCoord.out.bam.bai"), emit: bam_file
    tuple path("${sample_ID}_Log.out"), path ("${sample_ID}_Log.final.out"), path("${sample_ID}_Log.progress.out"), 
    path("${sample_ID}_ReadsPerGene.out.tab"),
    path("${sample_ID}_SJ.out.tab"), emit: star_report
    path "versions.yml", emit: versions

    script:
    """
    STAR --genomeDir ${star_index} \
    --runThreadN ${task.cpus} \
    --readFilesIn ${fq1} ${fq2} \
    --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within \
    --outSAMattributes Standard --quantMode GeneCounts \
    --readFilesCommand gunzip -c --outFileNamePrefix ${sample_ID}_ \
    --chimSegmentMin 12 --chimJunctionOverhangMin 8 \
    --chimOutJunctionFormat 1 --alignSJDBoverhangMin 10 \
    --alignMatesGapMax 100000 --alignIntronMax 100000 \
    --chimOutType WithinBAM

    samtools index ${sample_ID}_Aligned.sortedByCoord.out.bam


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        star: \$(STAR --version | sed -e "s/STAR_//g")
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
        gawk: \$(echo \$(gawk --version 2>&1) | sed 's/^.*GNU Awk //; s/, .*\$//')
    END_VERSIONS

    """
}
