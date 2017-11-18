function delete_ligand_tertiary_contacts()

tags = get_tags( 'TertiaryContact' ); 
for i = 1:length( tags ); 
    tc = getappdata( gca, tags{i} ); 
    res = getappdata( gca, tc.associated_residues1{1});  
    if isfield(res,'ligand_partners');
        delete_tertiary_contact( tags{i} );
    end; 
end;