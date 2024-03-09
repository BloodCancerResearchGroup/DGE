process STAR_QUALIMAP {
    label "low"
    tag "${sample_ID}"

    input:
    tuple val(sample_ID), path(BAM), path(BAM_INDEX)
    path(gtf)

    output:
    tuple val(sample_ID), path("${sample_ID}_qualimap"), emit: star_qualimap
    path "versions.yml", emit: versions

    """
    qualimap rnaseq -outdir ./${sample_ID}_qualimap -bam ${BAM} -p strand-specific-reverse \
    -gtf ${gtf} --java-mem-size=10G


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
    qualimap: \$(qualimap 2>&1 | grep 'QualiMap v.' | sed -E 's/.*QualiMap v\.([^-]+).*/\1/')
    END_VERSIONS
    """
}

//    tuple val(sample_ID), path ("./${sample_ID}_qualimap/qualimapReport.html"), emit: star_qualimap
//    path "./${sample_ID}_qualimap/css"
//    path "./${sample_ID}_qualimap/images_qualimapReport"
//    path "./${sample_ID}_qualimap/raw_data_qualimapReport"
//    path "./${sample_ID}_qualimap/rnaseq_qc_results.txt"