process REMOVE_DUP {
  tag "$sample"
  errorStrategy 'terminate'


  publishDir ( params.outdirdup ?: "${projectDir}/4.Remove_Duplication" ), mode: 'copy', overwrite: true

  input:
    tuple val(sample), path(b1)

  output:
     tuple val(sample),
            path("${sample}.dedup.bam")

  script:
  """
    samtools sort -n -@ ${task.cpus} -o ${sample}.name.bam  ${b1} 
    samtools fixmate -m -@ ${task.cpus} ${sample}.name.bam ${sample}.fixmate.bam
    samtools sort -@ ${task.cpus} -o ${sample}.coord.bam ${sample}.fixmate.bam
    samtools markdup -@ ${task.cpus} -r ${sample}.coord.bam ${sample}.dedup.bam
    samtools index -@ ${task.cpus} ${sample}.dedup.bam
    
    rm -f ${sample}.name.bam ${sample}.fixmate.bam ${sample}.coord.bam
  """
}
