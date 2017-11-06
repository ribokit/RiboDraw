function coaxial_stacks = get_coaxial_stacks( base_pairs, base_stacks, stems );
% coaxial_stacks = get_coaxial_stacks( base_pairs, base_stacks, stems );
%
% * define a graph of stacked pairs. Then let's see if we can get connected
%   components.
% * consecutive pairs in helix stems are assumed to always qualify as stacked pairs.
% * if a residue is in a helix stem, other pairs (e.g. triplet
%    interactions) are excluded from seeding new coaxial stacks. 
%
% (C) Rhiju Das, Stanford University, 2017

base_pairs = filter_out_extra_base_pairs_for_stem_residues( base_pairs, stems );
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
fprintf( 'Calculating stacked_pairs (this could be accelerated)\n' );
for h = 1:length( all_base_pairs )
    base_pair = all_base_pairs{h};    

    for i = 1:length( all_base_stacks )
        base_stack = all_base_stacks{i};
        if ( base_stack.resnum1 == base_pair.resnum1 & ...
             base_stack.chain1  == base_pair.chain1 & ...
             base_stack.segid1  == base_pair.segid1 )
             
             for j = 1:length( all_base_pairs )
                 other_base_pair = all_base_pairs{j};
                 if ( other_base_pair.resnum1 == base_stack.resnum2 & ...
                      other_base_pair.chain1 == base_stack.chain2 & ...
                      other_base_pair.segid1 == base_stack.segid2)
                      
                      for k = 1:length( all_base_stacks )
                          other_base_stack = all_base_stacks{k};
                          if ( other_base_stack.resnum2 == other_base_pair.resnum2 & ...
                               other_base_stack.chain2 == other_base_pair.chain2 & ...
                               other_base_stack.segid2 == other_base_pair.segid2 )
                               
                               if ( other_base_stack.resnum1 == base_pair.resnum2 & ...
                                    other_base_stack.chain1  == base_pair.chain2 & ...
                                    other_base_stack.segid1  == base_pair.segid2 )
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

% create a graph and then find connected_components
g = addnode( graph(), length( base_pairs ) );

% the ordering here is to find unique base pairs in the graph
for i = 1:length( stacked_pairs )
    idx1 = find_in_doublets( base_pairs, ordered_base_pair( stacked_pairs{i}.base_pair1 ) );
    idx2 = find_in_doublets( base_pairs, ordered_base_pair( stacked_pairs{i}.base_pair2 ) );
    g = addedge( g, idx1, idx2 );
end

fprintf( 'Working out coaxial stacks from graph\n' );
coaxial_stacks = get_coaxial_stacks_from_graph( g, base_pairs, all_base_stacks, stems );

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
function base_stacks = include_stacks_for_stems( base_stacks, stems );
for i = 1 : length( stems)
    stem = stems{i};
    base_stacks = add_stacks( base_stacks, stem.resnum1, stem.chain1, stem.segid1 );
    base_stacks = add_stacks( base_stacks, stem.resnum2, stem.chain2, stem.segid2 );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function base_stacks = add_stacks( base_stacks, stem_resnum, stem_chain, stem_segid );
stem_length = length( stem_resnum );
for j = 1:stem_length-1
    stack.resnum1= stem_resnum(j);
    stack.chain1 = stem_chain(j);
    stack.segid1 = stem_segid{j};
    stack.resnum2= stem_resnum(j+1);
    stack.chain2 = stem_chain(j+1);
    stack.segid2 = stem_segid{j+1};
    stack.side = 'A';
    stack.orientation = 'P';
    idx = find_in_doublets( base_stacks, stack );
    if ( idx == 0 )
        % fprintf( 'Missing stem stack in base_stacks: %s%d-%s%d\n', stack.chain1, stack.resnum1, stack.chain2, stack.resnum2 );
        base_stacks = [base_stacks, stack ];
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function filtered_base_pairs = filter_out_extra_base_pairs_for_stem_residues( base_pairs, stems );
stem_res     = {};
stem_partner = {};
for i = 1:length( stems )
    stem = stems{i};
    L = length( stem.resnum1 );
    for j = 1:L
        stem_res    = [stem_res,     sprintf('%s%s%d',stem.chain1(j),stem.segid1{j},stem.resnum1(j)) ];
        stem_partner = [stem_partner, sprintf('%s%s%d',stem.chain2(L-j+1),stem.segid2{L-j+1},stem.resnum2(L-j+1))];
    end
end

for i = 1:length( stem_res )
    stem_res     = [stem_res, stem_partner{i} ];
    stem_partner = [stem_partner, stem_res{i} ];
end

% only allow the canonical pairs for stem residues:
filtered_base_pairs = {};
for i = 1:length( base_pairs )
    base_pair = base_pairs{i};
    reschain1 = sprintf('%s%s%d',base_pair.chain1,base_pair.segid1,base_pair.resnum1 );
    reschain2 = sprintf('%s%s%d',base_pair.chain2,base_pair.segid2,base_pair.resnum2 );
    if ( any(strcmp( stem_res, reschain1 )) | any(strcmp( stem_res, reschain2 )) )
        gp = find( strcmp( stem_res, reschain1 ) );
        if isempty( gp ); continue; end;
        if ~strcmp( stem_partner(gp), reschain2 ) continue; end;
        assert( strcmp( stem_partner( strcmp( stem_res, reschain2 ) ), reschain1 ) );
    end
    filtered_base_pairs = [filtered_base_pairs, base_pair ];
end

