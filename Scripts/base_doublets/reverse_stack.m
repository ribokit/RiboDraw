function new_stack = reverse_stack( base_stack );
%  base_stack = reverse_stack( base_stack );
%
%  Input:
%   base_stack = struct with resnum1, chain1, resnum2, chain2
%
%  Output:
%   new_stack = same as input, but switching residues 1 and 2.
%
% (C) R. Das, Stanford University, 2017

new_stack.resnum2 = base_stack.resnum1;
new_stack.chain2 = base_stack.chain1;
new_stack.segid2 = base_stack.segid1;

new_stack.resnum1 = base_stack.resnum2;
new_stack.chain1 = base_stack.chain2;
new_stack.segid1 = base_stack.segid2;

new_stack.orientation = base_stack.orientation;
new_stack.side = find_other_side( base_stack.side, base_stack.orientation );

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