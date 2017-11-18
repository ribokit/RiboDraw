function [residues, associated_helices] = get_res_helix_for_selection( selection );
residues = {};
associated_helices = {};
for i = 1:length( selection.associated_residues )
    residue = getappdata( gca, selection.associated_residues{i} );
    residues{i} = residue;
    associated_helices = unique([associated_helices, residue.helix_tag ]);
end