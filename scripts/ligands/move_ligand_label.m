function move_ligand_label(h)
% move_ligand_label( handle )
% 
% Update figure (gca) info after dragging
%  a ligand (domain or coaxial stack)
% 
% (C) R. Das, Stanford University

pos = get(h,'position'); 
ligand_tag = getappdata( h, 'ligand_tag' );
ligand = getappdata( gca, ligand_tag );
ligand.label_relpos = get_relpos( pos(1:2), getappdata(gca,ligand.helix_tag) );
setappdata( gca, ligand_tag, ligand );