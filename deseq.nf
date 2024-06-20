process DESEQ2 {
    publishDir(path: "$baseDir", mode: 'copy', overwrite: 'true')
    input:
        path(csv)
        val(run_name)
        path(salmon_index)
        path(transcript_fa)
        path(gtf)

    output: 
        path("results")

    """
    Rscript $baseDir/bin/deseq2_create_objects.R ${csv} ${run_name} $baseDir ${salmon_index} ${transcript_fa} ${gtf}
    """
}
def deseqRunName = params.deseq_run_name ?: "deseq2_all"
workflow {
    DESEQ2( 
        params.sampleCSV,  
        deseqRunName,
        params.salmon_index,
        params.transcript_fa,
        params.gtf)
}