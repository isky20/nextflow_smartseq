process QC_OK {
    tag "$sample"

    input:
    tuple val(sample), path(r1), path(r2)
    path(read_pairs_trim_file) 
    path(qc_script)

    output:
    path "${sample}.OK.txt",   emit: ok,   optional: true
    path "${sample}.FAIL.txt", emit: fail, optional: true

    tuple val(sample), path(r1), path(r2), emit: ok_pairs, optional: true


    shell:
    '''
    python3 !{qc_script} !{read_pairs_trim_file}
    


    '''
}
