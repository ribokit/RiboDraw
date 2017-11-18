function draw_linkers()
% draw_linkers()
% Redraws all linkers.
tags = get_tags( 'Linker' );
for i = 1:length( tags )
    draw_linker( getappdata( gca, tags{i} ) );
end
