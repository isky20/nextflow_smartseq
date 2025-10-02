// Step 1: Run Trim Adaptor in process
process TRIM_ADAPTOR {
  tag "$sample"
  errorStrategy 'terminate'


  publishDir ( params.outdir ?: "${projectDir}/2.trimmed" ), mode: 'copy', overwrite: true

  input:
  tuple val(sample), path(r1), path(r2) 
  path adapters 

  output:
  tuple val(sample),
        path("${sample}_R1.trim.fastq.gz"),
        path("${sample}_R2.trim.fastq.gz")

  script:
  """
  echo "Sample: ${sample}"
  echo "R1: ${r1}"
  echo "R2: ${r2}"
  echo "Adapters: ${adapters}"

  fastq-mcf ${adapters} ${r1} ${r2} \
    -o ${sample}_R1.trim.fastq.gz \
    -o ${sample}_R2.trim.fastq.gz \
    -q 30 -l 35 -t ${task.cpus}
  """
}

