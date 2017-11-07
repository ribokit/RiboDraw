function ligands = read_ligands( ligand_file );

fid = fopen( ligand_file );
ligands = {};
while ~feof( fid )
    line = fgetl( fid );
    % B     protein     R:6 R:8-9 R:11
    cols = strsplit( line, ' ' );
    if length( cols ) >= 3 
        clear ligand
        ligand.chain = cols{1}(1);
        ligand.segid = '';
        if length( cols{1} ) > 1 & strcmp( cols{1}(2), ':' )
            ligand.segid = cols{1}(3:end);
        end
        ligand.name  = cols{2};
        [resnum,chains,segid] = get_resnum_from_tag( strjoin(cols(3:end)) );
        ligand.ligand_partners = {};
        for i = 1:length( resnum )
            ligand.ligand_partners = [ ligand.ligand_partners, sprintf( 'Residue_%s%s%d',  chains(i), segid{i}, resnum(i) ) ];
        end
        ligands = [ligands,ligand];
    end;
end

