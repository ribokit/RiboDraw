function [reschainseg, idx] = min_res_chain( reschainseg1, reschainseg2 )
% [reschainseg, idx] = min_res_chain( reschainseg1, reschainseg2 )
% [reschainseg, idx] = min_res_chain( base_pair )
%
% Figures out 'minimum' res-chain-segid tuple to allow for sorting
%  of base-pairs or base-pair stacks.
%
% First sorts by chain, then by segid, then by resnum.
%
% Inputs
%  reschainseg1 = cell of {resnum (int), chain (char), segid (string)}
%  reschainseg2 = cell of {resnum (int), chain (char), segid (string)}
%
% *or*
%
%  base_pair [its {resnum1, chain1,segid1}, {resnum2,chain2,segid2} will be used]
%
% Output
%  reschainseg = cell of 'minimum' {resnum,chain,segid}
%  idx         = 1 or 2 depending on whether minimum was first or second input reschainseg.
%
% (C) R. Das, Stanford University

if nargin == 1
    pair = reschainseg1;
    assert( isstruct(pair) );
    [reschainseg,idx] = min_res_chain(...
        {pair.resnum1, pair.chain1, pair.segid1 }, ...
        {pair.resnum2, pair.chain2, pair.segid2 } );
    return;
end

res1   = reschainseg1{1};
chain1 = reschainseg1{2};
segid1 = reschainseg1{3};

res2   = reschainseg2{1};
chain2 = reschainseg2{2};
segid2 = reschainseg2{3};

if ( strgreaterthan( segid2, segid1 ) | ...
    ( strcmp(segid2,segid1) & ( chain2 > chain1 ) ) |  ...
        ( strcmp(segid2,segid1) & chain2 == chain1 & res2 > res1 ) )
    reschainseg = reschainseg1;
    idx = 1;
else
    reschainseg = reschainseg2;
    idx = 2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = strgreaterthan( a, b )

val = any( ~strcmp( sort( {a,b} ), {a,b} ) );

