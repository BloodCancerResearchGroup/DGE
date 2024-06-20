# Differential expression analysis based on: 
# https://www.bioconductor.org/packages/devel/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html#summarizedexperiment

library("tximeta")
library("DESeq2")
library("dplyr")
library("biomaRt")

# Parse arguments from a command line
args = commandArgs(trailingOnly=TRUE)

if (!dir.exists(paste0("./results/", args[2]))) {
  dir.create(paste0("./results/", args[2]), recursive = TRUE)
} else {
  print("Directory already exists.")
}

#Prepare directories
directory <- args[3]
directory

# Read metadata table
sample_metadata <- read.table(args[1], sep=',', header=TRUE, stringsAsFactors = FALSE)


# Ad $files columns with path to the quant.sf files (result from salmon)
sample_metadata$files <- paste0(args[3],"/processed/", sample_metadata$names, "/", sample_metadata$names, "_salmon/quant.sf")
#sample_metadata$files <- paste0(args[3],"/processed/", sample_metadata$names, "/salmon/quant.sf")
head(sample_metadata)

args
makeLinkedTxome(indexDir=args[4],
                source="LocalGENCODE",
                organism="Homo sapiens",
                release="13",
                genome="GRCh38",
                fasta=args[5],
                gtf=args[6],
                write=TRUE)

# Parse salmon result with tximeta
se <- tximeta(sample_metadata)

# summarize transcript counts to genes
gse <- summarizeToGene(se)
row.names(gse) = substr(rownames(gse), 1, 15)

# Construction of DESeqDataSet object
dds <- DESeqDataSet(gse, design = ~ patient + specimen)
dds$specimen <- relevel(dds$specimen, ref = "NDMM")

# Remove rows of the DESeqDataSet that have no counts, or only a single count across all samples
keep <- rowSums(counts(dds)) > 1
dds <- dds[keep,]
head(dds)
save(dds, file = paste0("./results/", args[2], "/dds.RData"))

# # EXPLORATORY ANALYSIS AND VISUALIZATION
# ########################################
# # counts normalization
 rld <- rlog(dds, blind = FALSE)
 save(rld, file = paste0("./results/", args[2], "/rld.RData"))

# dds <- DESeq(dds, betaPrior=FALSE) 
# counts_ = counts(dds, normalized=T)
# write.csv(counts_, file=paste0("./results/", args[2], "/norm_counts.csv"))

#res <- results(dds, contrast=c("specimen","MRD","NDMM"))

#prepare annotation
# res = subset(res, res$baseMean > 10)
# mart <- useMart("ENSEMBL_MART_ENSEMBL")
# mart <- useDataset("hsapiens_gene_ensembl", mart)
# annotLookup <- getBM(
#   mart=mart,
#   attributes=c("ensembl_gene_id", "gene_biotype", "external_gene_name", "description"),
#   filter="ensembl_gene_id",
#   values=rownames(res),
#   uniqueRows=TRUE)

# ############################
# # genes with no annotation
# problematic_ids = setdiff(rownames(res), annotLookup$ensembl_gene_id)

# fileConn <- file(paste0("./results/", args[2], "/annotation_problematic_ids.out"))
# writeLines(problematic_ids, fileConn)    
# close(fileConn)

#res <- subset(res, !(rownames(res) %in% problematic_ids))
#ens = rownames(res)

#annotate
# annotLookup <- data.frame(
#   ens[match(annotLookup$ensembl_gene_id, ens)],
#   annotLookup)
# colnames(annotLookup) <- c( 
#       "original_id", 
#       c("ensembl_gene_id", "gene_biotype", "external_gene_name", "description")) 
# res$symbol <- annotLookup$external_gene_name
# res$biotype <- annotLookup$gene_biotype
# res$description <- annotLookup$description
# # save results
#resOrdered <- res[order(res$padj),]
#resOrderedDF <- as.data.frame(resOrdered)
#write.csv(resOrderedDF, file = paste0("./results/", args[2], "/deseq_result_paired.csv"))

