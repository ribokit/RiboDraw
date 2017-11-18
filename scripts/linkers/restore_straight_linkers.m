function restore_straight_linkers( tags )
% restore_straight_linkers( tags )

for i = 1:length( tags )
    linker = getappdata( gca, tags{i} );
    linker = delete_linker( linker, 0 );
    linker = rmfield( linker, 'relpos1' );
    linker = rmfield( linker, 'relpos2' );
    setappdata( gca, tags{i}, linker );
    draw_linker( linker ); 
end
