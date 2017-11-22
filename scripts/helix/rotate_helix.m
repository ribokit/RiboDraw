function rotate_helix( h, ~, ~ )
% rotate_helix( h, ~, ~ )
%
% Rotate helix clockwise 90 degress around the helix center point.
% Called after user clicks on center point control.
%
% (C) R. Das, Stanford University, 2017

helix_tag = getappdata( h, 'helix_tag' );
helix = getappdata(gca,helix_tag );
helix.rotation = mod( helix.rotation + 90, 360 );
setappdata( gca, helix_tag, helix );
draw_helix( helix );

