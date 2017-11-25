function redraw_linkers()
% draw_linkers()
%
% Redraws all linkers.
% deprecated by allowing DRAW_LINKER to take a cell of tags as input.
%
tags = get_tags( 'Linker' );
for i = 1:length( tags )
    draw_linker( getappdata( gca, tags{i} ) );
end
