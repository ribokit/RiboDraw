function redraw_res_and_helix( h )
% Redraw residue and any other residues associated with its parent helix.
% Call this after dragging.
% (C) R. Das, Stanford University, 2017

pos = get(h,'position'); 
res_tag = getappdata( h, 'res_tag' );
delete( h );

residue = getappdata(gca,res_tag );
helix = getappdata( gca, residue.helix_tag );
undraw_helix( helix );

if length( pos ) == 4 % rectangle
    residue.plot_pos = [ pos(1) + pos(3)/2, pos(2) + pos(4)/2];
else
    residue.plot_pos = pos(1:2);
end

% need to figure out rel_pos back in the 'frame' of the helix.
% for that I need to figure out rotation matrix.
theta = helix.rotation;
R = [cos(theta*pi/180) -sin(theta*pi/180);sin(theta*pi/180) cos(theta*pi/180)];
R = [1 0; 0 helix.parity] * R;
residue.relpos = ( residue.plot_pos - helix.center ) * R';
setappdata( gca, res_tag, residue );
draw_helix( helix );


