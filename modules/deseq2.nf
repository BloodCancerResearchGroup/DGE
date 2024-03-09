process DESEQ2 {

    input:
        val("sample_ID/*")
        path(csv)
        val(run_name)
        path(salmon_index)
        path(transcript_fa)
        path(gtf)

    output: 
        path("results")

    """
    sleep 2m 
    Rscript $baseDir/bin/deseq2_create_objects.R ${csv} ${run_name} $baseDir ${salmon_index} ${transcript_fa} ${gtf}
    """
}
