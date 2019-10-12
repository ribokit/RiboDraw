function base_pairs = get_base_pairs_from_stems( stems )
% base_pairs = get_base_pairs_from_stems( stems )
%
%  Infer base pairs (only Watson-Crick pairs) from stems
%
% See also: SETUP_BASE_PAIRS
% 
% (C) R. Das, Stanford University, 2019
base_pairs = {};
for n = 1:length( stems )
    stem = stems{n};
    N = length( stem.resnum1 );
    for k = 1:N
        base_pair = struct();
        base_pair.resnum1 = stem.resnum1(k);
        base_pair.chain1 = stem.chain1(k);
        base_pair.segid1 = stem.segid1{k};
        base_pair.resnum2 = stem.resnum2(N-k+1);
        base_pair.chain2 = stem.chain2(N-k+1);
        base_pair.segid2 = stem.segid2{N-k+1};
        base_pair.edge1 = 'W';
        base_pair.edge2 = 'W';
        base_pair.LW_orientation = 'C';
        base_pairs = [ base_pairs, {base_pair} ];
    end
end
