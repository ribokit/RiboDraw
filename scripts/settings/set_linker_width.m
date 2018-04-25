function set_linker_width( fontsize )
% set_linker_width( fontsize )
%
% Update linker width based on a heuristic for scaling to fontsize,
%   in GET_ARROW_LINEWIDTH.
%
% TODO: wrap this functionality inside set_fontsize and draw_linker.
%
% (C) R. Das, Stanford University.

arrow_linewidth = get_arrow_linewidth( fontsize );
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actually go and fix up lines
tags = get_tags( 'Linker_','arrow');
for i = 1:length( tags );
    linker = getappdata( gca, tags{i} );
    if isfield( linker, 'line_handle' ) && isvalid( linker.line_handle )
        set( linker.line_handle, 'linewidth', arrow_linewidth );
    end
end
