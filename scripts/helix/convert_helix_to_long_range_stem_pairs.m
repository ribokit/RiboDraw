function convert_helix_to_long_range_stem_pair( helix_tag )
% convert_helix_to_long_range_stem_pair( helix_tag )

helix = getappdata( gca, helix_tag );
N = length( helix.resnum1 );
res_tags = {};
for j = 1:N
    linker_tag = sprintf('Linker_%s%s%d_%s%s%d_stem_pair', helix.chain1(j), helix.segid1{j}, helix.resnum1(j),...
        helix.chain2(N-j+1), helix.segid2{j}, helix.resnum2(N-j+1) );
%     res_tags = [res_tags, {sprintf('Residue_%s%s%d',helix.chain1(j), helix.segid1{j}, helix.resnum1(j))} ];
%     res_tags = [res_tags, {sprintf('Residue_%s%s%d', helix.chain2(N-j+1), helix.segid2{j}, helix.resnum2(N-j+1))} ];
    if isappdata( gca, linker_tag )
        linker = getappdata( gca, linker_tag );
        linker.type = 'long_range_stem_pair';
        linker.edge1 = 'W';
        linker.edge2 = 'W';
        linker.LW_orientation = 'C';
        if isfield( linker, 'line_handle' ) delete( linker.line_handle ); rmfield( linker, 'line_handle' ); end;
        if isfield( linker, 'symbol' ) delete( linker.symbol ); rmfield( linker, 'symbol' ); end;
        linker_tag = strrep( linker_tag, 'stem_pair','long_range_stem_pair' );
        if ~isappdata( gca, linker_tag )
            setappdata( gca, linker_tag, linker );
        end
        draw_linker( linker_tag );
    end
end

% need to also track the residues and assign to closest helix.
helix_tags = get_tags( 'Helix' );
helix_tags = setdiff( helix_tags, helix_tag );
stems = {};
for n = 1:length( helix_tags )
    stems{n} = getappdata(gca,helix_tags{n});
end
for n = 1:length( stems )
    stem_start1(n) = stems{n}.resnum1(1);
    stem_stop1 (n) = stems{n}.resnum1(end);
    stem_chain1(n) = stems{n}.chain1(1);
    stem_segid1(n) = stems{n}.segid1(1);
    stem_start2(n) = stems{n}.resnum2(1);
    stem_stop2 (n) = stems{n}.resnum2(end);
    stem_chain2(n) = stems{n}.chain2(1);
    stem_segid2(n) = stems{n}.segid2(1);
end

res_tags = get_res();
helix_tags_to_redraw = {};
for i = 1:length(res_tags)
    res_tag = res_tags{i};
    residue = getappdata( gca, res_tag );
    if ~strcmp( residue.helix_tag, helix_tag ); continue; end;
    dists1 = Inf * ones( 1, length( stems ) );
    dists2 = Inf * ones( 1, length( stems ) );
    chain = residue.chain;
    segid = residue.segid;
    res = residue.resnum;
    m = strfind( stem_chain1, chain );
    dists1(m) = min( abs( stem_start1(m) - res ), abs( abs(stem_stop1(m) - res) ) ); 
    m = strfind( stem_chain2, chain );
    dists2(m) = min( abs( stem_start2(m) - res ), abs( abs(stem_stop2(m) - res) ) ); 
    dists = min( dists1, dists2 );
    [~,n] = min( dists );
    stems{n}.associated_residues = unique( [ stems{n}.associated_residues, {res_tag} ] );
    setappdata( gca, stems{n}.helix_tag, stems{n} );

    residue.helix_tag = stems{n}.helix_tag;
    setappdata( gca, res_tag, residue );
    update_residue_after_helix_reassignment( residue );
end

rmgraphics( helix, {'label','rectangle','reflect_line1','reflect_line2','click_center'});
rmappdata( gca, helix_tag )