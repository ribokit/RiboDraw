function cleanup_stray_linkers()
linkers = get_tags( 'Linker' );
for i = 1:length( linkers )
    linker = getappdata( gca, linkers{i} );
    if ~isappdata( gca, linker.residue1 ) | ~isappdata( gca, linker.residue2 )
        fprintf( 'Removing problem linker %s\n', linkers{i} );
        rmappdata( gca, linkers{i} );
    end
end