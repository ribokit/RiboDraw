function base_stacks = read_base_stacks( base_stacks_file )
fid = fopen( base_stacks_file );
base_stacks = {};
while ~feof( fid )
    line = fgetl( fid );
    % C:1347 C:1599 W W C 
    cols = strsplit( line, ' ' );
    if length( cols ) >= 4       
        [base_stack.resnum1,base_stack.chain1] = get_resnum_from_tag( cols{1} );
        [base_stack.resnum2,base_stack.chain2] = get_resnum_from_tag( cols{2} );
        base_stack.side = cols{3};
        base_stack.orientation = cols{4};
        base_stacks = [base_stacks, base_stack];
    end;
end

