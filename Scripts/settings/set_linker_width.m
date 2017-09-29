function set_linker_width( fontsize )
% set_linker_width( fontsize )

arrow_linewidth = max( 0.6, fontsize*1.5/10 );
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actually go and fix up lines
tags = get_tags( 'Linker_','arrow');
for i = 1:length( tags );
    linker = getappdata( gca, tags{i} );
    if isfield( linker, 'line_handle' )
        set( linker.line_handle, 'linewidth', arrow_linewidth );
    end
end
