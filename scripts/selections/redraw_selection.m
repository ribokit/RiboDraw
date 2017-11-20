function redraw_selection( h );
% redraw_selection( handle );
%   Called after dragging a domain or coaxial stack. 
%
% (C) Rhiju Das, Stanford University, 2017.

delete_crosshair();
pos = get(h,'position'); 
init_pos = getappdata(h,'initial_position');
selection_tag = getappdata( h, 'selection_tag' );
selection = getappdata(gca,selection_tag );

translation = pos - init_pos;

[residues, associated_helices] = get_res_helix_for_selection( selection );

for i = 1:length( residues )
    residues{i}.plot_pos = residues{i}.plot_pos + translation(1:2);
end

for i = 1:length( associated_helices )
    helix = getappdata( gca, associated_helices{i} );
    helix.center = helix.center + translation(1:2);
    setappdata( gca, helix.helix_tag, helix );
    draw_helix( helix );
end

