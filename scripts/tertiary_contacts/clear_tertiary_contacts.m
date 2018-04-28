function clear_tertiary_contacts()
% clear_tertiary_contact()
%
% Remove all tertiary contacts.
%
% (C) R. Das, Stanford University, 2018

contact_name = get_tags( 'TertiaryContact' );
textprogressbar( 'Deleting tertiary contacts ' );
for i = 1:length( contact_name );
    delete_tertiary_contact( contact_name{i}, 0);
textprogressbar( i/length(contact_name) );
end
textprogressbar( ' done' );

