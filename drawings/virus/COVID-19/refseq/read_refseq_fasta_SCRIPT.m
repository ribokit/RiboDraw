fastafiles = {'SARS_refseq.fasta','MHV_refseq.fasta','MERS_refseq.fasta'};

for i = 1:length( fastafiles )
    fastafile = fastafiles{i};
    S = fastaread( fastafile );
    fid = fopen( strrep(fastafile,'refseq.fasta','refseq_RNA.txt'), 'w' );
    fprintf( fid, '%s\n', strrep(S.Sequence,'T','U') );
    fclose(fid);
end



