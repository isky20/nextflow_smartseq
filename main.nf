#!/usr/bin/env nextflow
nextflow.enable.dsl=2

workflow {

  Channel
    .fromFilePairs(params.reads, flat: true)    
    .map { it -> tuple(sample= it[0], r1= it[1], r2= it[2]) }  
    .set { read_pairs }

  // 2) Single-value channel for adapters and Run the trimmer
  adapters     = Channel.value(file(params.adapters))
  index_dir_ch = Channel.value(file(params.index))
  gtf_ch       = Channel.value(file(params.gtf))
  qc_script = Channel.value(file(params.qc_script))
  
  
  trimfq = TRIM_ADAPTOR(read_pairs, adapters)

  
  trimfq
    .map( it -> tuple(sample= it[0], t1= it[1], t2= it[2]))
    .set { read_pairs_trim }
  


  
  read_pairs_trim_file = QC_SEQKIT(read_pairs_trim)

  QC_OK(read_pairs_trim,read_pairs_trim_file,qc_script)

 
 
  
  // 3) Run the aligner
  bams = ALIGN_STAR(QC_OK.out.ok_pairs,index_dir_ch,gtf_ch)
 
  bams
    .map(it -> [sample= it[0], b1= it[1]])
    .set{ bam_files}
  
  // 5) Remove duplicates
  bams_dep = REMOVE_DUP(bam_files)
   
  bams_dep
    .map( it -> [bams_dep= it[1]] )
    .set{ bam_dedup_files}
    
  // 6) Count matrix
  COUNTMATRIX(bam_dedup_files.collect() ,gtf_ch)
 

}





include { TRIM_ADAPTOR } from '/home/isky20/02.project/01.ultravitromics/00.code/01.trim.nf'

include { QC_SEQKIT } from '/home/isky20/02.project/01.ultravitromics/00.code/011.QC_SEQKIT.nf'
include { QC_OK } from '/home/isky20/02.project/01.ultravitromics/00.code/012.QC_OK.nf'


include { ALIGN_STAR } from '/home/isky20/02.project/01.ultravitromics/00.code/02.align.nf'

include { REMOVE_DUP } from '/home/isky20/02.project/01.ultravitromics/00.code/03.removedup.nf'
include { COUNTMATRIX } from '/home/isky20/02.project/01.ultravitromics/00.code/04.count.nf'
