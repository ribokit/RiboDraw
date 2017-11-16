function remove_ligands_from_helix_groups()

tags = get_tags( 'Residue_' );
for i = 1:length( tags )
    tag = tags{i};
    ligand = getappdata( gca, tag );
    if ~isfield( ligand, 'ligand_partners' ) continue; end; 
    selections = ligand.associated_selections;
    for j = 1:length( selections )
        if ~isempty(strfind(selections{j},'helixgroup'))
            remove_residues_from_domain( ligand.res_tag, selections{j} );
        end
    end
end