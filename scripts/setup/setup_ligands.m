function setup_ligands( ligands )
% setup_ligands( ligands )
%
% Draw ligands as 'Residue' objects in the current drawing (gca).
%
% Input:
%  ligands = cell of ligand objects (initialized from READ_LIGANDS )
%
% (C) R. Das, Stanford University, 2017

if ischar( ligands ) ligands = read_ligands( ligands ); end;
for i = 1:length(ligands)
    ligand = ligands{i};
    ligand.resnum = 0; % fitting ligand into 'residue' framework.
    ligand.res_tag = sprintf( 'Residue_%s%s%d', ligand.chain,ligand.segid,ligand.resnum);
    ligand.name = [ligand.original_name,' ',ligand.chain,ligand.segid];

    % get this ligand into global data (gca)
    if ~isappdata( gca, ligand.res_tag ) setappdata( gca, ligand.res_tag, ligand ); end

    % add linkers
    possible_helix_tags = {};
    ligand.linkers = {};
    for j = 1:length( ligand.ligand_partners )
        linker = struct();
        linker.residue1 = ligand.res_tag;
        linker.residue2 = ligand.ligand_partners{j};
        linker.type = 'ligand';
        
        partner = getappdata( gca, linker.residue2 );
        linker_tag = sprintf('Linker_%s%s%d_%s%s%d_%s',...
            ligand.chain,ligand.segid,ligand.resnum,...
            partner.chain,partner.segid,partner.resnum,...
            linker.type);
        linker.linker_tag = linker_tag;
        
        % stick this linker information in the connected residues.

        ligand.linkers = [ ligand.linkers, linker_tag ];
        add_linker_to_residue( linker.residue2, linker_tag );
        if ~isappdata( gca, linker_tag ) setappdata( gca, linker_tag, linker ); end;
        
        possible_helix_tags = [ possible_helix_tags, partner.helix_tag ];
    end
 
    unique_helix_tags = unique( possible_helix_tags );
    helix_tag_count = zeros( 1, length( unique_helix_tags ) );
    for n = 1:length( unique_helix_tags )
        helix_tag_count( n ) = length( find( strcmp( unique_helix_tags{n}, possible_helix_tags ) ) );
    end
    [~,idx] = max( helix_tag_count );
    
    ligand.helix_tag = unique_helix_tags{ idx };
    ligand.relpos    = [10,0]; % wild guess
    if isappdata( gca, ligand.res_tag ) % keep ligand but update linkers
        ligand_original = getappdata( gca, ligand.res_tag );
        ligand_original.linkers = ligand.linkers;
        if ~isfield( ligand_original, 'helix_tag' ) ligand_original.helix_tag = ligand.helix_tag; end;
        setappdata( gca, ligand.res_tag, ligand_original );
    else
        setappdata( gca, ligand.res_tag, ligand ); 
    end;
    
    ligands{i} = ligand;
end

helices = {};
for i = 1:length( ligands )
    ligand = getappdata( gca, ligands{i}.res_tag );
    helix = getappdata( gca, ligand.helix_tag );
    helix.associated_residues = unique( [ helix.associated_residues, ligand.res_tag ] );
    setappdata( gca, ligand.helix_tag, helix );
    helices = [ helices, ligand.helix_tag ];
end
draw_helices( unique( helices ) );
move_stuff_to_back(); % move linkers to back.
