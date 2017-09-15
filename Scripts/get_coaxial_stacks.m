function g = get_coaxial_stacks( base_pairs, base_stacks, stems );
% coaxial_stacks = get_coaxial_stacks( base_pairs, base_stacks );
%
% (C) Rhiju Das, Stanford University, 2017

% define a graph of stacked pairs. Then let's see if we can get connected
% components?
base_pairs = fill_base_normal_orientations( base_pairs );
base_stacks = include_stacks_for_stems( base_stacks, stems );

% cleaner code (at the expense of increased computation) in testing base stack information
all_base_stacks = base_stacks;
for i = 1:length( base_stacks )
    all_base_stacks = [ all_base_stacks, reverse_stack( base_stacks{i} ) ];
end

all_base_pairs = base_pairs;
for i = 1:length( base_pairs )
    all_base_pairs = [ all_base_pairs, reverse_pair( base_pairs{i} ) ];
end

% to save time, a kind of hash map
% for i = 1:length( all_base_stacks )
%     stack =all_base_stacks{i};
%     all_base_stack_tags{i} = sprintf( '%s%d%s%d', stack.chain1,stack.resnum1,stack.chain2,stack.resnum2 );
% end
% for i = 1:length( all_base_pairs )
%     pair =all_base_pairs{i};
%     all_base_pair_tags{i} = sprintf( '%s%d%s%d', pair.chain1,pair.resnum1,pair.chain2,pair.resnum2 );
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% accumulate list of stacked_pairs
% figure out possible base pairs that stack on this base pair.
%
%          stack
%        1      2
%      1 X  --  Z 1
%  pair  |      | other_pair
%      2 Y  --  W 2
%        1      2
%        other_stack
%
% Just 'go around the loop'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stacked_pairs = {};

% TODO: speed this up with hash of residue/chain that stack and/or pair
% with each other reschains

for i = 1:length( all_base_pairs )
    base_pair = all_base_pairs{i};    

    for i = 1:length( all_base_stacks )
        base_stack = all_base_stacks{i};
        if ( base_stack.resnum1 == base_pair.resnum1 & ...
             base_stack.chain1  == base_pair.chain1 )
             
             for j = 1:length( all_base_pairs )
                 other_base_pair = all_base_pairs{j};
                 if ( other_base_pair.resnum1 == base_stack.resnum2 & ...
                      other_base_pair.chain1 == base_stack.chain2 )
                      
                      for k = 1:length( all_base_stacks )
                          other_base_stack = all_base_stacks{k};
                          if ( other_base_stack.resnum2 == other_base_pair.resnum2 & ...
                               other_base_stack.chain2 == other_base_pair.chain2 )
                               
                               if ( other_base_stack.resnum1 == base_pair.resnum2 & ...
                                    other_base_stack.chain1  == base_pair.chain2 )
                                   % add_stacked_pair() will create unique
                                   % entry, and track how many times its
                                   % found, which better be 2x2 = 4 times
                                   stacked_pairs = add_stacked_pair( stacked_pairs, base_pair, base_stack, other_base_pair, other_base_stack );
                               end
                          end
                      end
                      
                 end
             end
        end
    end    
end

length( stacked_pairs )

% create a graph and then find connected_components
g = addnode( graph(), length( base_pairs ) );

% the ordering here is to find unique base pairs in the graph
for i = 1:length( stacked_pairs )
    idx1 = find_in_doublets( base_pairs, ordered_base_pair( stacked_pairs{i}.base_pair1 ) );
    idx2 = find_in_doublets( base_pairs, ordered_base_pair( stacked_pairs{i}.base_pair2 ) );
    g = addedge( g, idx1, idx2 );
end

% within each connected component, create an ordering of base pairs.
bins = conncomp( g );
max( bins )

% check that all stems are connected,
% and get rid of co-axial stacks that are 'just' stems
just_a_stem = zeros( 1, max(bins) );
for i = 1 : length( stems)
    stem = stems{i};
    stem_length = length( stem.resnum1 );
    stem_bins = [];
    for j = 1:stem_length
        base_pair.resnum1 = stem.resnum1(j); 
        base_pair.chain1  = stem.chain1(j);
        base_pair.resnum2 = stem.resnum2(stem_length-j+1); 
        base_pair.chain2  = stem.chain2(stem_length-j+1);
        base_pair.edge1 = 'W';
        base_pair.edge2 = 'W';
        base_pair.LW_orientation = 'C';
        base_pair.orientation = 'A';
        idx = find_in_doublets( base_pairs, ordered_base_pair(base_pair) );
        stem_bins = [stem_bins, bins( idx )];
    end
    stem_bin = unique( stem_bins );
    assert( length( stem_bin ) == 1 );
    if length( find( bins == stem_bin ) ) == stem_length;
        just_a_stem( stem_bin ) = 1;
    end
end

% how many coaxial stacks are left when we get rid of stems?
length( find( just_a_stem == 0 ) );

% OK let's pull out the coaxial stacks...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function idx = find_in_doublets( base_pairs, base_pair );
idx = 0;
for i = 1:length( base_pairs )
    if isequal( base_pairs{i}, base_pair ) idx = i; break; end;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_stack = reverse_stack( base_stack );
new_stack.resnum2 = base_stack.resnum1;
new_stack.chain2 = base_stack.chain1;
new_stack.resnum1 = base_stack.resnum2;
new_stack.chain1 = base_stack.chain2;
new_stack.orientation = base_stack.orientation;
new_stack.side = find_other_side( base_stack.side, base_stack.orientation );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_pair = reverse_pair( base_pair );
new_pair.resnum2 = base_pair.resnum1;
new_pair.chain2 = base_pair.chain1;
new_pair.edge2 = base_pair.edge1;
new_pair.resnum1 = base_pair.resnum2;
new_pair.chain1 = base_pair.chain2;
new_pair.edge1 = base_pair.edge2;
new_pair.orientation = base_pair.orientation;
new_pair.LW_orientation = base_pair.LW_orientation;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_side = find_other_side( side, orientation );
switch orientation
    case 'P'
        new_side = side;
    case 'A'
        new_side = switch_side( side );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_side = switch_side( side );
switch side
    case 'A'
        new_side = 'B';
    case 'B'
        new_side = 'A';
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stacked_pairs = add_stacked_pair( stacked_pairs, base_pair, base_stack, other_base_pair, other_base_stack );
stacked_pair = ordered_stacked_pair( base_pair, other_base_pair );
for i = 1:length( stacked_pairs )
    if isequal( stacked_pair, stacked_pairs{i} )
        return;
    end
end
stacked_pairs = [stacked_pairs, stacked_pair];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [reschain, idx] = min_res_chain( reschain1, reschain2 )

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
    reschain = reschain2;
    idx = 1;
else
    reschain = reschain1;
    idx = 2;
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function base_pair = ordered_base_pair( base_pair );
[~,idx] = min_res_chain( base_pair );
if ( idx == 2 ) 
    base_pair = reverse_pair( base_pair );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function base_stacks = include_stacks_for_stems( base_stacks, stems );

for i = 1 : length( stems)
    stem = stems{i};
    base_stacks = add_stacks( base_stacks, stem.resnum1, stem.chain1 );
    base_stacks = add_stacks( base_stacks, stem.resnum2(end:-1:1), stem.chain2(end:-1:1) );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function base_stacks = add_stacks( base_stacks, stem_resnum, stem_chain );
stem_length = length( stem_resnum );
for j = 1:stem_length-1
    stack.resnum1= stem_resnum(j);
    stack.chain1 = stem_chain(j);
    stack.resnum2= stem_resnum(j+1);
    stack.chain2 = stem_chain(j+1);
    stack.side = 'A';
    stack.orientation = 'P';
    idx = find_in_doublets( base_stacks, stack );
    if ( idx == 0 )
        fprintf( 'Missing stem stack in base_stacks: %s%d-%s%d\n', stack.chain1, stack.resnum1, stack.chain2, stack.resnum2 );
        base_stacks = [base_stacks, stack ];
    end
end
