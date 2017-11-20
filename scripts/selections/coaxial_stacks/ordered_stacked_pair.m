function stacked_pair = ordered_stacked_pair( base_pair, other_pair ); 
% stacked_pair = ordered_stacked_pair( base_pair, other_pair ); 
%
% Get a uniquely ordered stacked_pair object based on the component two base_pairs. 
%
% Convention:
% * Choose base pair based on minimum index (lowest chain, then
%    lowest resnum)
% * Then second pair should be aligned so that its res1 stacks on the first
%    pair's res1 and so that its res2 stacks on the first
%    pair's res2.
% 
% Note:
%  The base pairs that are installed into the ordered_stacked_pair may not themselves be
%    ordered as they would from the ordered_base_pair function.
%
% INPUTS
%  base_pair  = one of the base pairs that is stacked
%  other_pair = the other base pairs involved in the stack.
%
% OUTPUT
%  stacked_pair = ordered stacked_pair object
%
% (C) R. Das, Stanford University, 2017

reschain = min_res_chain( min_res_chain( base_pair ), min_res_chain( other_pair ) );

% TODO -- update to handle segid in addition to chain!!
res = reschain{1};
chain = reschain{2};
if     ( base_pair.resnum1 == res & base_pair.chain1 == chain )
    stacked_pair.base_pair1 = base_pair;
    stacked_pair.base_pair2 = other_pair;
elseif ( base_pair.resnum2 == res & base_pair.chain2 == chain )
    stacked_pair.base_pair1 = reverse_pair( base_pair );
    stacked_pair.base_pair2 = reverse_pair( other_pair );
elseif ( other_pair.resnum1 == res & other_pair.chain1 == chain )
    stacked_pair.base_pair1 = other_pair;
    stacked_pair.base_pair2 = base_pair;
elseif ( other_pair.resnum2 == res & other_pair.chain2 == chain )
    stacked_pair.base_pair1 = reverse_pair( other_pair );
    stacked_pair.base_pair2 = reverse_pair( base_pair );
end
