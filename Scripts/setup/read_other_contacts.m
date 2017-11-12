function other_contacts = read_other_contacts( other_contacts_file )
fid = fopen( other_contacts_file );
other_contacts = {};
while ~feof( fid )
    line = fgetl( fid );
    % C:1347 C:1599 O2' N3 
    cols = strsplit( line, ' ' );
    if length( cols ) >= 4       
        [other_contact.resnum1,other_contact.chain1,other_contact.segid1] = get_one_resnum_from_tag( cols{1} );
        [other_contact.resnum2,other_contact.chain2,other_contact.segid2] = get_one_resnum_from_tag( cols{2} );
        other_contact.atom1 = cols{3};
        other_contact.atom2 = cols{4};
        other_contacts = [other_contacts, other_contact];
    end;
end

