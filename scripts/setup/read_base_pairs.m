function base_pairs = read_base_pairs( base_pairs_file )
% base_pairs = read_base_pairs( base_pairs_file )
%
%  Read .base_pairs.txt file output by Rosetta rna_motif executable, which
%      should include all Watson-Crick and non-Watson-Crick pairs.
%
% INPUT
%
%  base_pairs_file = text file with lines like
%
%                      A:1  B:20 W H C
%
%                    i.e.,
%
%                      chain1[:segid1]:resnum1 chain2[:segid2]:resnum2  edge1  edge2  LW_orientation
%
%                    where edge           is W/H/S (Watson-Crick/Hoogsteen/Sugar) and
%                          LW_orientation is C/T (cis/trans based on how the two base's glycosidic bond 
%                                                   are oriented relative to the base-to-base connector)
%
%
% OUTPUT
%
%  base_pairs       = cell of struct()s with the same information. Reordered so that 
%                         the residue that has an earlier chain/segid (or if same, earlier resnum) is first.
%
%
% See also: SETUP_BASE_PAIRS, READ_BASE_STACKS
% 
% (C) R. Das, Stanford University, 2017

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

