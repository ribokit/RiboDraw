function cleanup_stack_linkers()
linkers = get_tags( 'Linker','stack' );
for i = 1:length( linkers )
    linker = getappdata( gca, linkers{i} );
    if strcmp(linker.type,'base_stack')
        linker.type = 'stack';
        fprintf( 'Updating base_stack linker type to stack %s\n', linkers{i} );
        setappdata( gca, linkers{i}, linker );
    end
end