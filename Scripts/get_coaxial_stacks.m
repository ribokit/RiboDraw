function coaxial_stacks = get_coaxial_stacks( base_pairs, base_stacks );
% coaxial_stacks = get_coaxial_stacks( base_pairs, base_stacks );
%
% (C) Rhiju Das, Stanford University, 2017

% define a graph of stacked pairs. Then let's see if we can get connected
% components?
base_pairs = fill_base_normal_orientations( base_pairs );

% cleaner code (at the expense of increased computation) in testing base stack information
all_base_stacks = base_stacks;
for i = 1:length( base_stacks )
    all_base_stacks = [ base_stacks, reverse_stack( base_stacks{i} ) ];
end

all_base_pairs = base_pairs;
for i = 1:length( base_pairs )
    all_base_pairs = [ base_pairs, reverse_pair( base_pairs{i} ) ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% accumulate list of stacked_pairs
% figure out possible base pairs that stack on this base pair.
%
%          stack
%        1      2
%      1 X  --  Z 1
%  pair  |      | other_pair
%      2 Y  --  W 2
%        2      1
%        other_stack
%
% Just 'go around the loop'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stacked_pairs = {};
for i = 1:length( all_base_pairs )
    base_pair = all_base_pairs{i};    
    
    for i = 1:length( all_base_stacks )
        base_stack = all_base_stacks{i};
        if ( base_stack.resnum1 == base_pair.resnum1 &
             base_stack.chain1  == base_pair.chain1 )
             
             for j = 1:length( all_base_pairs )
                 other_base_pair = all_base_pairs{j};
                 if ( other_base_pair.resnum1 == base_stack.resnum2 & 
                      other_base_pair.chain1 == base_stack.chain2 )
                      
                      for k = 1:length( all_base_stacks )
                          other_base_stack = all_base_stacks{k};
                          if ( other_base_stack.resnum1 == other_base_pair.resnum2 &
                               other_base_stack.chain1 == other_base_pair.chain2 )
                               
                               if ( other_base_stack.resnum2 == base_pair.resnum2 &
                                    other_base_stack.chain2  == base_pair.chain2 )
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

% within each connected component, create an ordering of base pairs.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_stack = reverse_stack( base_stack );
new_stack.resnum2 = base_stack.resnum1;
new_stack.chain2 = base_stack.chain1;
new_stack.resnum1 = base_stack.resnum2;
new_stack.chain1 = base_stack.chain2;
new_stack.orientation = base_stack.orientation;
new_stack.side = find_other_side( base_stack.side, base_stack.orientation );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_side = find_other_side( side, orientation );
switch orientation
    case 'P'
        new_side = side;
    case 'A'
        new_side = switch_side( side );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_side = switch_side( side );
switch side
    case 'A'
        new_side = 'B'
    case 'B'
        new_side = 'A'
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  stacked_pair = ordered_stacked_pair( base_pair, other_pair, side, which_res, which_res_in_other ); 
if ( base_pair.chain1 > other_pair.chain1 ) |
    ( base_pair.chain1 == partner.chain1 & base_pair.resnum1 > other_pair.resnum1 )
    stacked_pair = 
end
    




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Following was skeleton code -- did not flesh out.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% combine above information to determine stacked_pairs, along with number
% of votes (which can go up to 4).
% for i = 1:length( base_pairs )
%     partners = unique( base_pair.possible_partnersA );
%     for j = 1:length( partners )
%         partner = partners{j};
%         stacked_pair = ordered_stacked_pair( {base_pair, partner}, 'A' ); % choose ordering.
%         stacked_pairs = increase_count( stacked_pair, stacked_pairs ); % add to list, or find in list and increase count
%     end
%     % ditto for other side.
% end
% 
% % break ties. give warning if failure to break ties; in that case choose based on sequence
% % distance. 
% %
% % degeneracy counts min number of partners for each pair in stacked pair. 1 is
% % good. 
% %
% stacked_pairs = sort_by_count_and_degeneracy_and_sequence_distance( stacked_pairs );
% filtered_stacked_pairs = {};
% stacked_pair_ok = ones( 1, length( stacked_pairs ) );
% for i = 1:length( stacked_pairs )
%     if ( stacked_pair_ok(i) )
%         stacked_pair = stacked_pairs{i};
%         filtered_stacked_pairs = [filtered_stacked_pairs, stacked_pair ];
%         for j = i+1 : length( stacked_pairs )
%             if shares_base_pair_and_side( stacked_pairs{j}, stacked_pair );
%                 if stacked_pairs{j}.count == stacked_pair.count &&
%                     stacked_pairs{j}.degeneracy == stacked_pair.degeneracy )
%                     fprintf( 'Warning, found tie; relying on sequence distance!\n' );
%                 end
%                 stacked_pair_ok( j ) = 0;
%             end
%         end
%     end
% end

% group coax stacks together, paying attention to directionality.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [base_pairs_that_stack,which_res_in_pair] = get_base_pairs_stack( resnum, chain, side, base_pairs, base_stacks );
% base_pairs_that_stack = {};
% which_res_in_pair = [];
% 
% % first find residues that stack
% stack_partner_resnum = {};
% stack_partner_chain = {};
% for i = 1:length( base_stacks )
%     base_stack = base_stacks{i};
%     for n = 1:2
%         if ( base_stack.resnum1 == resnum &
%              base_stack.chain1 == chain &
%              base_stack.side == side )
%             stack_partner_resnum = [stack_partner_resnum, base_stack.resnum2];
%             stack_partner_chain  = [stack_partner_chain,  base_stack.chain2 ];
%         end
%         base_stack = reverse_stack( base_stack );
%     end
% end    
% 
% % then find base pairs that include those residues that stack
% for j = 1:length( base_pairs )
%     base_pair = base_pairs{j};
%     gp = find( strcmp( stack_partner_chain, base_pair.chain1 ) & (stack_partner_resnum == base_pair.resnum1 ) );
%     if ~isempty( gp ) 
%         base_pairs_that_stack = [ base_pairs_that_stack, base_pair ]; 
%         which_res_in_pair = [ which_res_in_pair, 1 ];
%     end;
%     gp = find( strcmp( stack_partner_chain, base_pair.chain2 ) & (stack_partner_resnum == base_pair.resnum2 ) );
%     if ~isempty( gp ) 
%         base_pairs_that_stack = [ base_pairs_that_stack, base_pair ]; 
%         which_res_in_pair = [ which_res_in_pair, 2 ];
%     end;
% end



