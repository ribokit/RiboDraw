function coaxial_stacks = get_coaxial_stacks( base_pairs, base_stacks );
% coaxial_stacks = get_coaxial_stacks();
% coaxial_stacks = get_coaxial_stacks( base_pairs, base_stacks );
%
% (C) Rhiju Das, Stanford University, 2017

if nargin < 1; 
    base_pairs  = get_base_pairs_from_gca();
    base_stacks = get_base_stacks_from_gca();
end

% define a graph of stacked pairs. Then let's see if we can get connected
% components?
base_pairs = fill_base_normal_orientations( base_pairs );

% accumulate list of stacked_pairs
stacked_pairs = {};
for i = 1:length( base_pairs )
    base_pair = base_pairs{i};
    
    % figure out possible base pairs that stack on "side A" of res1 of this base pair.
    %   X 1
    %   | | 
    %   Y 2
    base_pairs_stack1 = get_base_pairs_stack( base_pair.resnum1, base_pair.chain1, 'A', base_pairs, base_stacks );

    % ditto for res2 (though now look for its "side B", depending on orientation)
    which_side = 'A';
    if ( base_pair.orientation == 'A' ) which_side = 'P'; end;
    base_pairs_stack2 = get_base_pairs_stack( base_pair.resnum2, base_pair.chain2,  which_side, base_pairs, base_stacks );
    
    % If there are several winners, how can we break ties? maybe store them
    % all, as well as 'other side'. List will have redundancies that count
    % 'votes' for each stacked_pair
    base_pair.possible_partnersA = [base_pair.possible_partners, base_pairs_stack1, base_pairs_stack2];
end

% Repeat above for 'other side' of each base_pair.
% actually merge next code block and above to just generate stacked_pair
% list.

% combine above information to determine stacked_pairs, along with number
% of votes (which can go up to 4).
for i = 1:length( base_pairs )
    partners = unique( base_pair.possible_partnersA );
    for j = 1:length( partners )
        partner = partners{j};
        stacked_pair = ordered_stacked_pair( {base_pair, partner}, 'A' ); % choose ordering.
        stacked_pairs = increase_count( stacked_pair, stacked_pairs ); % add to list, or find in list and increase count
    end
    % ditto for other side.
end

% break ties. give warning if failure to break ties; in that case choose based on sequence
% distance. 
%
% degeneracy counts min number of partners for each pair in stacked pair. 1 is
% good. 
%
stacked_pairs = sort_by_count_and_degeneracy_and_sequence_distance( stacked_pairs );
filtered_stacked_pairs = {};
stacked_pair_ok = ones( 1, length( stacked_pairs ) );
for i = 1:length( stacked_pairs )
    if ( stacked_pair_ok(i) )
        stacked_pair = stacked_pairs{i};
        filtered_stacked_pairs = [filtered_stacked_pairs, stacked_pair ];
        for j = i+1 : length( stacked_pairs )
            if shares_base_pair_and_side( stacked_pairs{j}, stacked_pair );
                if stacked_pairs{j}.count == stacked_pair.count &&
                    stacked_pairs{j}.degeneracy == stacked_pair.degeneracy )
                    fprintf( 'Warning, found tie; relying on sequence distance!\n' );
                end
                stacked_pair_ok( j ) = 0;
            end
        end
    end
end

% group coax stacks together, paying attention to directionality.



