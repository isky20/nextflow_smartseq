process QC_SEQKIT {
    tag "$sample"
    publishDir ( params.outdirqc ?: "${projectDir}/011.QC" ), mode: 'copy', overwrite: true

    input:
    tuple val(sample), path(t1), path(t2)

    output:
    path "${sample}.qc.txt"

    script:
    """

    # Run seqkit stats with full paths
    seqkit stats -j 4 -a $t1 $t2  > ${sample}.qc.txt
    """
}
