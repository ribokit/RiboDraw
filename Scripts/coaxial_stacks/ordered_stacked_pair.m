function  stacked_pair = ordered_stacked_pair( base_pair, other_pair ); 
% convention -- choose base pair based on minimum index (lowest chain, then
%  lowest resnum)
% then second pair should be ailgned so that its res1 stacks on the first
%  pair's res1
% and so that its res2 stacks on the first
%  pair's res2.
reschain = min_res_chain( min_res_chain( base_pair ), min_res_chain( other_pair ) );
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
