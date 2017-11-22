function base_pair = ordered_base_pair( base_pair );
%  base_pair = ordered_base_pair( base_pair );
%
%  Make sure that first residue is lower
%   in chain/segid (or in residue number, if chains/segids are same) than
%   second residue in base pair. (Reverse pair if that isn't so.)
%
%  Input:
%   base_pair = struct with resnum1, chain1, resnum2, chain2
%
%  Output:
%   base_pair = ordered base pair
%
% (C) R. Das, Stanford University, 2017

[~,idx] = min_res_chain( base_pair );
if ( idx == 2 ) 
    base_pair = reverse_pair( base_pair );
end