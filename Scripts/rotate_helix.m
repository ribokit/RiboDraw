function rotate_helix( h, ~, ~ )
disp( 'clicky')
helix_tag = getappdata( h, 'helix_tag' )
helix = getappdata(gca,helix_tag );
helix.rotation = mod( helix.rotation + 90, 360 );
helix
undraw_helix( helix );
draw_helix( helix );


