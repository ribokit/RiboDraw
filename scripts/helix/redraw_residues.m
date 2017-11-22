function redraw_residues( residues )
% redraw_residues( residues )
%
% Redraw all residues, e.g., after autoformatting a coaxial stack.
%  The function does this by finding the helices to which the
%  residues belong and redrawing those helices.
%
% Input:
%  residues = cell of residue objects to redraw.
%
% (C) R. Das, Stanford University, 2017

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
