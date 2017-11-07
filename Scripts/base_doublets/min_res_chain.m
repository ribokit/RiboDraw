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
%  reschain1 = cell of {resnum (int), chain (char), segid (string)}
%  reschain2 = cell of {resnum (int), chain (char), segid (string)}
% *or*
%  base_pair [its {resnum1, chain1,segid1}, {resnum2,chain2,segid2} will be used]
%
% Output
%  reschain = cell of 'minimum' {resnum,chain,segid}
%  idx      = 1 or 2 depending on whether minimum was first or second input reschain.
%
% (C) R. Das, Stanford University

if nargin == 1
    pair = reschain1;
    assert( isstruct(pair) );
    [reschain,idx] = min_res_chain(...
        {pair.resnum1, pair.chain1, pair.segid1 }, ...
        {pair.resnum2, pair.chain2, pair.segid2 } );
    return;
end

res1   = reschain1{1};
chain1 = reschain1{2};
segid1 = reschain1{3};

res2   = reschain2{1};
chain2 = reschain2{2};
segid2 = reschain2{3};

if ( strgreaterthan( segid2, segid1 ) | ...
    ( strcmp(segid2,segid1) & ( chain2 > chain1 ) ) |  ...
        ( strcmp(segid2,segid1) & chain2 == chain1 & res2 > res1 ) )
    reschain = reschain1;
    idx = 1;
else
    reschain = reschain2;
    idx = 2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = strgreaterthan( a, b )

val = any( ~strcmp( sort( {a,b} ), {a,b} ) );

