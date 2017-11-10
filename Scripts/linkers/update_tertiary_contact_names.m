function update_tertiary_contact_names()

tags = get_tags( 'Tertiary' );
for i = 1:length( tags )
    tertiary_contact = getappdata( gca, tags{i} );
    residue1 = getappdata( gca, tertiary_contact.associated_residues1{1} );
    residue2 = getappdata( gca, tertiary_contact.associated_residues2{1} );
    if isfield( residue1, 'helix_tag' ) & isfield( residue2, 'helix_tag' )
        helix1 = getappdata( gca, residue1.helix_tag );
        helix2 = getappdata( gca, residue2.helix_tag );
        name1 = get_helix_name( helix1, residue1 );
        name2 = get_helix_name( helix2, residue2 );
        tertiary_contact.name = [ name1, '-', name2 ];
        fprintf( 'Setting tertiary contact name %s for contact %s\n', tertiary_contact.name,tags{i} );
        setappdata( gca, tags{i}, tertiary_contact );
        if isfield( tertiary_contact, 'interdomain_linker' ); draw_linker( tertiary_contact.interdomain_linker ); end;
    end   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function name = get_helix_name( helix, residue )


helix_res_tag = sprintf( 'Residue_%s%s%d', helix.chain1(1), helix.segid1{1}, helix.resnum1(1) );
helix_residue = getappdata( gca, helix_res_tag );
if isfield( helix_residue, 'associated_selections' )
    tags = get_tags( 'Selection', 'helixgroup_domain',helix_residue.associated_selections);
    if length( tags ) > 0
        helixgroup = getappdata( gca, tags{1} );
        name = helixgroup.name;
        return;
    end
end

if length( helix.name ) > 0; 
    name = helix.name;
    return
end

name = sprintf( '%s%s%d', residue.chain,residue.segid, residue.resnum );


