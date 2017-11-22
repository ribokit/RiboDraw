function reflect_helix( h, ~, ~ )
% reflect_helix( h, ~, ~ )
%
% Reflect helix about its center axis.
% Called after user click on 'center line' controls.
%
% (C) R. Das, Stanford University, 2017

helix_tag = getappdata( h, 'helix_tag' );
helix = getappdata(gca,helix_tag );
helix.parity = helix.parity * -1;
setappdata( gca, helix_tag, helix );
draw_helix( helix );


