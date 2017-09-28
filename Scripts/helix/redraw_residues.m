function redraw_residues( residues )

% update relpos for all residues
helices_to_redraw = {};
for i = 1:length( residues )
    helix = getappdata( gca, residues{i}.helix_tag );
    residues{i}.relpos = get_relpos( residues{i}.plot_pos, helix );
    helices_to_redraw = [helices_to_redraw, helix.helix_tag ];
end

% ready to install residues into figure workspace (gca)
for i = 1:length( residues )
    residue = residues{i};
    setappdata( gca, residue.res_tag, residue );
end

% now redraw all helices that this domain involves
helices_to_redraw = unique( helices_to_redraw );
for i = 1:length( helices_to_redraw )
    helix = getappdata( gca, helices_to_redraw{i} );
    draw_helix( helix );
end
