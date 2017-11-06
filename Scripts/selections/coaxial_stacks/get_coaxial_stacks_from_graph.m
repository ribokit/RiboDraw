function coaxial_stacks = get_coaxial_stacks_from_graph( g, base_pairs, all_base_stacks, stems );
% OK let's pull out the coaxial stacks...
% within each connected component, create an ordering of base pairs.
bins = conncomp( g );
if( max(degree(g)) > 2 )
    fprintf('Warning! Some base pairs have more than two possible coaxial stack neighboring pairs!?');
end

% check that all stems are connected,
% and get rid of co-axial stacks that are 'just' stems
just_a_stem = zeros( 1, max(bins) );
in_stem = zeros( 1, length(bins) );
for i = 1 : length( stems)
    stem = stems{i};
    stem_length = length( stem.resnum1 );
    stem_bins = [];
    for j = 1:stem_length
        base_pair.resnum1 = stem.resnum1(j); 
        base_pair.chain1  = stem.chain1(j);
        base_pair.segid1  = stem.segid1{j};
        base_pair.resnum2 = stem.resnum2(stem_length-j+1); 
        base_pair.chain2  = stem.chain2(stem_length-j+1);
        base_pair.segid2  = stem.segid2{stem_length-j+1};
        base_pair.edge1 = 'W';
        base_pair.edge2 = 'W';
        base_pair.LW_orientation = 'C';
        base_pair.orientation = 'A';
        idx = find_in_doublets( base_pairs, ordered_base_pair(base_pair) );
        in_stem( idx ) = i;
        stem_bins = [stem_bins, bins( idx )];
    end
    stem_bin = unique( stem_bins );
    assert( length( stem_bin ) == 1 );
    if length( find( bins == stem_bin ) ) == stem_length;
        just_a_stem( stem_bin ) = 1;
    end
end

coax_size = [];
for i = 1 : max( bins )
    coax_size(i) = length( find( bins == i ) );
end

coaxial_stacks = {};
for i = 1:max( bins )
     if ( just_a_stem( i ) ); continue;  end;
     coax_pair_idx = find( bins == i );
     if ( length( coax_pair_idx ) == 1 ); continue; end; % don't bother with singlets

     % edge pairs
     edge_idx = find( degree(g, coax_pair_idx) == 1 );
     assert( length( edge_idx ) == 2 );

     % Need to find which edge pair has lowest index. Reuse the code in 'ordered_stack_pair'
     % Note that there is no guarantee that we'll traverse any group of
     % residues (even in a helix stem) from 5' to 3'!
     stacked_pair = ordered_stacked_pair( ...
         base_pairs{coax_pair_idx(edge_idx(1))}, ...
         base_pairs{coax_pair_idx(edge_idx(2))} );     
     current_pair = stacked_pair.base_pair1;  % note that this may not be ordered
     current_idx = find_in_doublets( base_pairs, ordered_base_pair( current_pair ) );
     coax_idx   = [current_idx]; % index in base_pairs list
     coax_pairs = { current_pair };
     for j = 1:length( coax_pair_idx )-1
         nbr_idx = neighbors( g, current_idx );
         next_idx = setdiff( nbr_idx, coax_idx );
         assert( length( next_idx ) == 1 );
         coax_idx = [ coax_idx, next_idx ];
         % base_pairs{next_idx} is the next pair, but we want to find the
         % ordering of its residues that maintains continuous stacks for
         % res1 and res2 all the way through the stack.
         next_pair = figure_out_next_pair_in_stack( current_pair, base_pairs{next_idx}, all_base_stacks );
         coax_pairs = [ coax_pairs, next_pair ];
         current_idx = next_idx;
         current_pair = next_pair;
     end
     coaxial_stack.coax_pairs = coax_pairs;

     % save information on associated_residues 
     associated_residues = {};
     for j = 1:length( coax_pairs )
         associated_residues = [ associated_residues, sprintf( 'Residue_%s%s%d', coax_pairs{j}.chain1,coax_pairs{j}.segid1,coax_pairs{j}.resnum1 ) ];
         associated_residues = [ associated_residues, sprintf( 'Residue_%s%s%d', coax_pairs{j}.chain2,coax_pairs{j}.segid2,coax_pairs{j}.resnum2 ) ];
     end
     coaxial_stack.associated_residues = associated_residues;
     
     % save information on associated_helices.
     stem_idx = sort( unique( setdiff( in_stem( coax_pair_idx ), [0] ) ) );
     associated_helices = {};
     for idx = stem_idx
         associated_helices = [ associated_helices, sprintf( 'Helix_%s%s%d', stems{idx}.chain1(1), stems{idx}.segid1{1}, stems{idx}.resnum1(1) ) ];
     end
     coaxial_stack.associated_helices = associated_helices;

     coaxial_stacks = [ coaxial_stacks, coaxial_stack];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function next_pair = figure_out_next_pair_in_stack( current_pair, ordered_next_pair, all_base_stacks );
if check_stacked_pair_ordering( current_pair, ordered_next_pair, all_base_stacks )
    next_pair = ordered_next_pair;
else
    next_pair = reverse_pair( ordered_next_pair );
    assert( check_stacked_pair_ordering( current_pair, next_pair, all_base_stacks ) ); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ok = check_stacked_pair_ordering( current_pair, next_pair, all_base_stacks )
% this is probably slower than it needs to be. Oh well! Doesn't need to be
% called very much. There's a similar (longer) set of nested loops in
% get_coaxial_stacks that should be optimized before this one... just
% need a hash/map.
ok1 = 0;
ok2 = 0;
for i = 1:length( all_base_stacks )
    base_stack = all_base_stacks{i};
    if ( current_pair.resnum1 == base_stack.resnum1 & ...
            strcmp(current_pair.chain1,base_stack.chain1) & ...
            strcmp(current_pair.segid1,base_stack.segid1))
        if (next_pair.resnum1 == base_stack.resnum2 & ...
            strcmp(next_pair.chain1,base_stack.chain2) & ...
            strcmp(next_pair.segid1,base_stack.segid2))        
            ok1 = 1; break;
        end
    end
end

for i = 1:length( all_base_stacks )
    base_stack = all_base_stacks{i};
    if ( current_pair.resnum2 == base_stack.resnum1 & ...
            strcmp(current_pair.chain2,base_stack.chain1) & ...
            strcmp(current_pair.segid2,base_stack.segid1))
        if (next_pair.resnum2 == base_stack.resnum2 & ...
            strcmp(next_pair.chain2,base_stack.chain2) & ...
            strcmp(next_pair.segid2,base_stack.segid2))
            ok2 = 1; break;
        end
    end
end
ok = ok1 & ok2;
