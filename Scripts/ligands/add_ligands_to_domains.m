function add_ligands_to_domains()
% add_ligands_to_domains()

tags = get_tags( 'Residue_' );
for i = 1:length( tags )
    ligand_tag = tags{i};
    ligand = getappdata( gca, ligand_tag );
    if ~isfield( ligand, 'ligand_partners' ) continue; end;
    
    % look up parent helix
    helix_tag = ligand.helix_tag;
    
    % look up all partner residues associated with that parent helix
    % look up all domains associated with those partner residues
    domains = [];
    for j = 1:length( ligand.ligand_partners )
        residue = getappdata( gca, ligand.ligand_partners{j} );
        if strcmp( residue.helix_tag, helix_tag ) 
            associated_domains = get_tags( 'Selection','domain', residue.associated_selections );
            for k = 1:length( associated_domains )
                % hacky hack.
                if ( strfind( associated_domains{k}, 'helixgroup' ) ) continue; end;
                if ( strfind( associated_domains{k}, 'RNA' ) ) continue; end;
                domains = [ domains, associated_domains(k) ];
            end
        end
    end
    domains = unique( domains );
    
    % add this ligand to those domains
    for j = 1:length( domains )
        add_residues_to_domain( ligand_tag, domains{j} );
    end

end