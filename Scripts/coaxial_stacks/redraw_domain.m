function redraw_domain( h );
delete_crosshair();
pos = get(h,'position'); 
init_pos = getappdata(h,'initial_position');
domain_tag = getappdata( h, 'domain_tag' );
domain = getappdata(gca,domain_tag );

translation = pos - init_pos;

residues = {};
for i = 1:length( domain.associated_residues )
    residue = getappdata( gca, domain.associated_residues{i} );
    residue.plot_pos = residue.plot_pos + translation(1:2);
    residues{i} = residue;
end
for i = 1:length( domain.associated_helices )
    helix = getappdata( gca, domain.associated_helices{i} );
    helix.center = helix.center + translation(1:2);
    setappdata( gca, helix.helix_tag, helix );
end

redraw_residues( residues );
