function base_pairs = read_base_pairs( base_pairs_file )
fid = fopen( base_pairs_file );
base_pairs = {};
while ~feof( fid )
    line = fgetl( fid );
    % C:QA:1347 C:QA:1599 W W C 
    cols = strsplit( line, ' ' );
    if length( cols ) >= 5        
        [base_pair.resnum1,base_pair.chain1,base_pair.segid1] = get_one_resnum_from_tag( cols{1} );
        [base_pair.resnum2,base_pair.chain2,base_pair.segid2] = get_one_resnum_from_tag( cols{2} );
        base_pair.edge1 = cols{3};
        base_pair.edge2 = cols{4};
        base_pair.LW_orientation = cols{5};
        base_pairs = [base_pairs,ordered_base_pair(base_pair)];
    end;
end

