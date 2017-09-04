function reflect_helix( h, ~, ~ )
helix_tag = getappdata( h, 'helix_tag' );
helix = getappdata(gca,helix_tag );
helix.parity = helix.parity * -1;
undraw_helix( helix );
draw_helix( helix );


