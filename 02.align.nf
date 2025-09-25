process ALIGN_STAR {
  tag "$sample"
  errorStrategy 'terminate'


  publishDir ( params.outdirAlign ?: "${projectDir}/3.Align" ), mode: 'copy', overwrite: true

  input:
    tuple val(sample), path(t1), path(t2)
    path index
    path gtf

  output:
     tuple val(sample),
          path("${sample}.Aligned.sortedByCoord.out.bam"),
          path("${sample}.Log.final.out"),
          path("${sample}.SJ.out.tab")

  script:
  """
  STAR \
  --genomeDir ${index} \
  --readFilesIn ${t1} ${t2} \
  --readFilesCommand zcat \
  --runThreadN ${task.cpus} \
  --outSAMtype BAM SortedByCoordinate \
  --sjdbGTFfile ${gtf} \
  --sjdbOverhang 149 \
  --outFileNamePrefix "${sample}."

  """
}
    
