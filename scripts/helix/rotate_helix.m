function rotate_helix( h, ~, ~ )
helix_tag = getappdata( h, 'helix_tag' );
helix = getappdata(gca,helix_tag );
helix.rotation = mod( helix.rotation + 90, 360 );
setappdata( gca, helix_tag, helix );
draw_helix( helix );

