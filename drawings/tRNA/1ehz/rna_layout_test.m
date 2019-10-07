secstruct = '(((((((..((((........)))).(((((.......))))).....(((((.......))))))))))))....';
bps = convert_structure_to_bps( secstruct );
pairs = zeros( length(secstruct), 1 );
for i = 1:size( bps, 1 ); 
    pairs(bps(i,1)) = bps(i,2); 
    pairs(bps(i,2)) = bps(i,1); 
end;
sequence =  'gcggauuuagcucaguugggagagcgccagacugaagaucuggagguccuguguucgauccacagaauucgcacca';
rna_layout( pairs );
