function helices = read_stems( helix_file )
% helices = read_stems( helix_file )
%
%  Read .stems.txt file output by Rosetta rna_motif executable, which
%      should include all directly stacked Watson-Crick/G*U wobble pairs with
%      length of 2 base pairs or greater. 
%
% TODO: probably should change the data structure so that it has only one chain, segid 
%        for each strand of the helix.
%
% INPUT
%
%  helix_file = text file with lines like
%
%                      A:1-4  B:20-17
%
% OUTPUT
%
%  helices       = cell of struct()s with the same information and a helix_tag like 'Helix_A4'
%
% (C) R. Das, Stanford University, 2017.

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
            warning( 'WARNING! WARNING! No stem name found for %s/%s in file %. You might want to add a third field with names like P1, P1b, P2, etc.',cols{1},cols{2},helix_file);
        end
        helices = [helices,helix];
        helix.helix_tag = sanitize_tag(sprintf('Helix_%s%s%d',helix.chain1(1),helix.segid1{1},helix.resnum1(1)));
    end;
end
