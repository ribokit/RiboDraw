function new_pair = reverse_pair( base_pair );
%  base_pair = reverse_pair( base_pair );
%
%  Input:
%   base_pair = struct with resnum1, chain1, resnum2, chain2
%
%  Output:
%   new_pair = same as input, but switching residues 1 and 2.
%
% (C) R. Das, Stanford University, 2017
%
new_pair.resnum1 = base_pair.resnum2;
new_pair.chain1 = base_pair.chain2;
new_pair.segid1 = base_pair.segid2;
new_pair.edge1 = base_pair.edge2;

new_pair.resnum2 = base_pair.resnum1;
new_pair.chain2 = base_pair.chain1;
new_pair.segid2 = base_pair.segid1;
new_pair.edge2 = base_pair.edge1;

new_pair.orientation = base_pair.orientation;
new_pair.LW_orientation = base_pair.LW_orientation;

