function delete_tertiary_contact( contact_name, print_stuff )
% delete_tertiary_contact( contact_name )
%
% Remove tertiary contact with provided name, and associated linkers and graphical elements.
%
% Inputs:
%  contact_name = name used to set up tertiary contact (not the display name, typically instead something like 'Residue_C123_Residue_C45')
%  print_stuff  = verbose (default 1)
%
% See also CLEAR_TERTIARY_CONTACTS.
%
% (C) R. Das, Stanford University, 2017
if ~exist( 'contact_name', 'var' ) 
    contact_name = get_tags( 'TertiaryContact' );
end
if ~exist( 'print_stuff', 'var' ) print_stuff = 1; end;

if iscell( contact_name )
    for i = 1:length( contact_name )
        delete_tertiary_contact( contact_name{i}, print_stuff );
    end
    return;
elseif isappdata( gca, contact_name )
    tag = contact_name;
else
    contact_name_cleaned = strrep( strrep(contact_name, ' ', '_' ), '-', '_' ) ;
    tag = sprintf('TertiaryContact_%s', contact_name_cleaned );
    if ~isappdata( gca, tag )
        fprintf( 'Could not find %s or %s. Returning. \n', contact_name, tag );
        return;
    end
end

tertiary_contact = getappdata( gca, tag );

if isfield( tertiary_contact, 'linkers' ) 
    delete_linker( tertiary_contact.interdomain_linker );
    delete_linker( tertiary_contact.intradomain_linkers1 );
    delete_linker( tertiary_contact.intradomain_linkers2 );
    for i = 1:length( tertiary_contact.linkers );
        linker = getappdata( gca, tertiary_contact.linkers{i} );
        linker = rmfield( linker, 'tertiary_contact' );
        setappdata( gca, linker.linker_tag, linker );
    end
else    
    linker_tags = get_tags( 'Linker' ); %[ get_tags( 'Linker','interdomain' ); get_tags( 'Linker','intradomain' )];
    for i = 1:length( linker_tags )
        linker_tag = linker_tags{i};
        linker = getappdata( gca, linker_tag );
        if ~isfield( linker, 'tertiary_contact' ) continue; end;
        if strcmp( linker.tertiary_contact, tertiary_contact.tertiary_contact_tag )
            if print_stuff; fprintf( 'Deleting %s\n', linker_tag ); end;
            if strcmp(linker.type,'tertcontact_interdomain') || strcmp(linker.type,'tertcontact_intradomain')
                delete_linker( linker );
            else
                linker = rmfield( linker, 'tertiary_contact' );
                setappdata( gca, linker_tag, linker );
            end
        end
    end
end

if print_stuff; fprintf( 'Deleting %s\n', tag ); end;
rmappdata( gca, tag )


