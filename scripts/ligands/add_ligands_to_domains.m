function add_ligands_to_domains( tags )
% add_ligands_to_domains( tags )
%
% After reading in ligands its useful to associate them
%  pre-existing domains defined for RNA residues.
%
% This function uses the heuristic that the ligand should belong
%   to the same domains as its RNA residue partners.
%
% For convenience reasons, exceptions are made to any domain with 
%   the substring 'helixgroup' or '_RNA_'. 
% TODO: allow user to input this exclude list.
%
% Input
%  tags = 'Residue' tags for ligands to add to domains.
% 
% (C) R. Das, Stanford University, 2017

if ~exist( 'tags', 'var' ) tags = get_tags( 'Residue_' ); end;

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
                % TODO: let user provide an exclude_domains input that can override these choices.
                if ( strfind( associated_domains{k}, 'helixgroup' ) ) continue; end;
                if ( strfind( associated_domains{k}, '_RNA_' ) ) continue; end;
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