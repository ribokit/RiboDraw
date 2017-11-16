function update_tertiary_contact_names( tags, print_stuff )
% update_tertiary_contact_names( tags, print_stuff )
% update_tertiary_contact_names( tag, print_stuff )
%

if ~exist( 'print_stuff' ) print_stuff = 1; end;
if ~exist( 'tags','var' )
    tags = get_tags( 'Tertiary' );
end
if ischar( tags ); tags = {tags}; end;

for i = 1:length( tags )
    tertiary_contact = getappdata( gca, tags{i} );
    name1 = get_partner_name( tertiary_contact.associated_residues1{1}  );
    name2 = get_partner_name( tertiary_contact.associated_residues2{1}  );
    if length( name1 ) == 0; continue; end;
    if length( name2 ) == 0; continue; end;
    tertiary_contact.name = [ name1, '-', name2 ];
    if print_stuff; fprintf( 'Setting tertiary contact name %s for contact %s\n', tertiary_contact.name,tags{i} ); end;
    setappdata( gca, tags{i}, tertiary_contact );
    if isfield( tertiary_contact, 'interdomain_linker' ); draw_linker( tertiary_contact.interdomain_linker ); end;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function name = get_partner_name( res_tag )
residue = getappdata( gca, res_tag);
name = '';
if isfield( residue, 'ligand_partners' );
    name = residue.nucleotide;
    return;
elseif isfield( residue, 'helix_tag' )
    helix = getappdata( gca, residue.helix_tag );
    name = get_helix_name( helix, residue );
    return;
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


