
process MULTIQC { 
    publishDir(path: "${params.output}MultiQC", mode: 'copy', overwrite: 'true')
    
    input:
    path "trim_galore/*"
    path "trim_galore/*"
    path "trim_galore/*"
    path "ribodetector/*"
    path "salmon/*"
    path "star/*"
    path "qualimap/*"




    output:
    path "./multiqc_report.html"

    """
    multiqc .
    """

}