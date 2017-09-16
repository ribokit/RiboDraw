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
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_side = switch_side( side );
switch side
    case 'A'
        new_side = 'B';
    case 'B'
        new_side = 'A';
end