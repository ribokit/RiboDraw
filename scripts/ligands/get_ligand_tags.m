function ligand_tags = get_ligand_tags();
% ligand_tags = get_ligand_tags();

tags = get_tags( 'Residue' );
ligand_tags = {};
for i = 1:length( tags )
    residue = getappdata( gca, tags{i} );
    if isfield( residue, 'ligand_partners' );
        ligand_tags = [ligand_tags,tags{i} ];
    end
end

