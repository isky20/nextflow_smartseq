process COUNTMATRIX {
  tag "$sample"
  errorStrategy 'terminate'

  publishDir ( params.outdircount ?: "${projectDir}/5.count" ), mode: 'copy', overwrite: true

  input:
    path(bams)
    path gtf

  output:
    path("smartseq_counts.txt")

  script:
  """
  featureCounts -T ${task.cpus} -a ${gtf} -o smartseq_counts.txt -t exon -g gene_id -s 0 -p --countReadPairs -B -C -Q 10  ${bams}

  """
}