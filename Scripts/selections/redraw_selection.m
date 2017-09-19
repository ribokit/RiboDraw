function redraw_selection( h );
delete_crosshair();
pos = get(h,'position'); 
init_pos = getappdata(h,'initial_position');
selection_tag = getappdata( h, 'selection_tag' );
selection = getappdata(gca,selection_tag );

translation = pos - init_pos;

residues = {};
for i = 1:length( selection.associated_residues )
    residue = getappdata( gca, selection.associated_residues{i} );
    residue.plot_pos = residue.plot_pos + translation(1:2);
    residues{i} = residue;
end
for i = 1:length( selection.associated_helices )
    helix = getappdata( gca, selection.associated_helices{i} );
    helix.center = helix.center + translation(1:2);
    setappdata( gca, helix.helix_tag, helix );
end

redraw_residues( residues );
