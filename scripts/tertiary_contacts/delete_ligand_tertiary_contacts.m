function delete_ligand_tertiary_contacts()
% Go through each protein or other ligand and remove
%  tertiary contacts & grouped inter-domain linkers
%  associated with it. Useful when deciding how to
%  define which linkers to group for clarity in large RNPs.
%
% (C) R. Das, Stanford University

tags = get_tags( 'TertiaryContact' ); 
for i = 1:length( tags ); 
    tc = getappdata( gca, tags{i} ); 
    res = getappdata( gca, tc.associated_residues1{1});  
    if isfield(res,'ligand_partners');
        delete_tertiary_contact( tags{i} );
    end; 
end;