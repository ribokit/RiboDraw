function helices = read_helices( helix_file )

fid = fopen( helix_file );
helices = {};
while ~feof( fid )
    line = fgetl( fid );
    % A:1-4 B:5-8 HelixX
    cols = strsplit( line, ' ' );
    if length( cols ) == 3
        [helix.resnum1,helix.chain1] = get_resnum_from_tag( cols{1} );
        [helix.resnum2,helix.chain2] = get_resnum_from_tag( cols{2} );
        helix.name = cols{3};
        helices = [helices,helix];
    end;
end
