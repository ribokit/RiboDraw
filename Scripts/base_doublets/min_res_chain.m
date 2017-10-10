function [reschain, idx] = min_res_chain( reschain1, reschain2 )
% [reschain, idx] = min_res_chain( reschain1, reschain2 )
% [reschain, idx] = min_res_chain( base_pair )
%
% Figures out 'minimum' res-chain pair to allow for sorting
%  of base-pairs or base-pair stacks.
%
% First sorts by chain, then by resnum.
%
% Inputs
%  reschain1 = cell of {resnum (int), chain (char)}
%  reschain2 = cell of {resnum (int), chain (char)}
% *or*
%  base_pair [its {resnum1, chain1}, {resnum2,chain2} will be used]
%
% Output
%  reschain = cell of 'minimum' {resnum,chain}
%  idx      = 1 or 2 depending on whether minimum was first or second input reschain.
%
% (C) R. Das, Stanford University

if nargin == 1
    pair = reschain1;
    assert( isstruct(pair) );
    [reschain,idx] = min_res_chain(...
        {pair.resnum1, pair.chain1}, ...
        {pair.resnum2, pair.chain2} );
    return;
end

res1   = reschain1{1};
chain1 = reschain1{2};

res2   = reschain2{1};
chain2 = reschain2{2};

if ( chain2 > chain1 ) |  ...
        ( chain2 == chain1 & res2 > res1 )
    reschain = reschain1;
    idx = 1;
else
    reschain = reschain2;
    idx = 2;
end
    
