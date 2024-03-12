nextflow.enable.dsl=2
//load modules
include { TRIM_GALORE                                   } from './modules/trim_galore'
include { RIBO_DET                                      } from './modules/ribo_det'
include { SALMON                                        } from './modules/salmon'
include { STAR                                          } from './modules/star'
include { ADD_READ_GROUP                                } from './modules/add_read_group'
include { STAR_QUALIMAP                                 } from './modules/star_qualimap'
include { DESEQ2                                        } from './modules/deseq2'
include { MULTIQC                                       } from './modules/multiqc'
//validate necessary input
def paramsToCheck = [params.samples, params.sampleCSV, params.genome, params.gtf, params.salmon_index]
paramsToCheck.each { param -> file(param, checkIfExists: true) }

//set name the output dir name of deseq2
def deseqRunName = params.deseq_run_name ?: "default"

//Define channel for the parsing of csv file containg information about 
//The csv file is expected to contain columns "names", which denotes sapmle unique identifier and
//the columns fq1 and fq2, which should contain the files names of corresponding fastq files.
Channel
    .fromPath(params.sampleCSV)
    .splitCsv(header: true)
    .map { row -> 
        [row.names, "${params.samples}${row.fq1}", "${params.samples}${row.fq2}"] }
    .set { inv_samples }

//workflow definition
workflow {    

    TRIM_GALORE(inv_samples)

    RIBO_DET(TRIM_GALORE.out.fqs)

    SALMON(RIBO_DET.out.fqs, params.salmon_index)

    STAR(RIBO_DET.out.fqs, params.star_index)

    ADD_READ_GROUP(STAR.out.bam_file)

    STAR_QUALIMAP(ADD_READ_GROUP.out.bamrg, params.gtf)

    MULTIQC(
        TRIM_GALORE.out.trim_galore_report.collect{it[1]}.ifEmpty([]),
        TRIM_GALORE.out.trim_galore_report.collect{it[2]}.ifEmpty([]),
        TRIM_GALORE.out.fastqc.collect{it[1]}.ifEmpty([]),
        RIBO_DET.out.ribo_det_log.collect{it[1]}.ifEmpty([]),
        SALMON.out.salmon_quant.collect{it[1]}.ifEmpty([]),
        STAR.out.star_report.collect{it[1]}.ifEmpty([]),
        STAR_QUALIMAP.out.star_qualimap.collect{it[1]}.ifEmpty([]),
    )

    DESEQ2(SALMON.out.salmon_quant.collect{it[0]}.ifEmpty([]), 
        params.sampleCSV,  
        deseqRunName,
        params.salmon_index,
        params.transcript_fa,
        params.gtf)
}

