function base_pair = ordered_base_pair( base_pair );
%  base_pair = ordered_base_pair( base_pair );
%
%  Input:
%   base_pair = struct with resnum1, chain1, resnum2, chain2
%
%  Output:
%   base_pair = same as input, but make sure that first residue is lower
%                 in chain (or in residue number, if chains are same) than
%                 second residue.
%
% (C) R. Das, Stanford University, 2017

[~,idx] = min_res_chain( base_pair );
if ( idx == 2 ) 
    base_pair = reverse_pair( base_pair );
end