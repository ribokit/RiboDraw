function redraw_helix( h )
pos = get(h,'position'); 
helix_tag = getappdata( h, 'helix_tag' );
helix = getappdata(gca,helix_tag );

helix.center = [ pos(1) + pos(3)/2, pos(2) + pos(4)/2];
setappdata( gca, helix_tag, helix );

undraw_helix( helix );
draw_helix( helix );


