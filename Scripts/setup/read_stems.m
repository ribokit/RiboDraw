function helices = read_helices( helix_file )

fid = fopen( helix_file );
helices = {};
while ~feof( fid )
    line = fgetl( fid );
    % A:1-4 B:5-8 HelixX
    cols = strsplit( line, ' ' );
    if length( cols ) >= 2
        [helix.resnum1,helix.chain1,helix.segid1] = get_resnum_from_tag( cols{1} );
        [helix.resnum2,helix.chain2,helix.segid2] = get_resnum_from_tag( cols{2} );
        if length( cols ) > 2 
            helix.name = cols{3};
        else
            helix.name = '';
        end
        helices = [helices,helix];
        helix.helix_tag = sprintf('Helix_%s%s%d',helix.chain1(1),helix.segid1{1},helix.resnum1(1));
    end;
end
