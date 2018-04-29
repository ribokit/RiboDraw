function convert_long_range_stem_pair_to_stem_pair( helix_tag )
if ~exist( 'helix_tag','var')
    helix_tag = get_tags( 'Helix' );
end
if iscell( helix_tag )
    for i = 1:length( helix_tag) convert_long_range_stem_pair_to_stem_pair( helix_tag{i} ); end;
    return;
end
    
stem = getappdata( gca, helix_tag );
N = length( stem.resnum1 );
for k = 1:N
    res_tag1 = sprintf( '%s%s%d', stem.chain1(k), stem.segid1{k}, stem.resnum1(k) );
    res_tag2 = sprintf( '%s%s%d', stem.chain2(N-k+1), stem.segid2{N-k+1}, stem.resnum2(N-k+1) );
    linker_name = sprintf( 'Linker_%s_%s_long_range_stem_pair', res_tag1, res_tag2 );
    if isappdata( gca, linker_name )
        fprintf( 'Convert %s from long_range_stem_pair to stem_pair because it is in helix %s\n',linker_name,helix_tag );
        linker = getappdata( gca, linker_name );
        linker_new = linker;
        linker_new.linker_tag =  sprintf( 'Linker_%s_%s_stem_pair', res_tag1, res_tag2 );
        linker_new.type = 'stem_pair';
        if isfield( linker_new, 'symbol' ) linker_new = rmfield( linker_new, 'symbol' ); end;
        setappdata( gca, linker_new.linker_tag, linker_new );
        add_linker_to_residue( linker.residue1, linker_new.linker_tag );
        add_linker_to_residue( linker.residue2, linker_new.linker_tag );
        delete_linker( linker, 1 );
    end
end
