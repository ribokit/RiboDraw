function delete_tertiary_contact( contact_name, print_stuff )
% delete_tertiary_contact( contact_name )
%
% Remove tertiary contact with provided name, and associated linkers and graphical elements.
%
% Inputs:
%  contact_name = name used to set up tertiary contact (not the display name, typically instead something like 'Residue_C123_Residue_C45')
%  print_stuff  = verbose (default 1)
%
% (C) R. Das, Stanford University, 2017
if ~exist( 'contact_name', 'var' ) 
    contact_name = get_tags( 'TertiaryContact' );
end
if ~exist( 'print_stuff', 'var' ) print_stuff = 1; end;

if iscell( contact_name )
    for i = 1:length( contact_name );
        delete_tertiary_contact( contact_name{i}, print_stuff);
    end
    return;
end

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

linker_tags = [ get_tags( 'Linker','interdomain' ); get_tags( 'Linker','intradomain' )];
for i = 1:length( linker_tags )
    linker_tag = linker_tags{i};
    linker = getappdata( gca, linker_tag );
    if strcmp( linker.tertiary_contact, tertiary_contact.tertiary_contact_tag )
        if print_stuff; fprintf( 'Deleting %s\n', linker_tag ); end;
        delete_linker( linker );
    end
end

if print_stuff; fprintf( 'Deleting %s\n', tag ); end;
rmappdata( gca, tag )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function linkers = setup_intradomain_linkers( res_tags, contact_name, tag );
linkers = {};
for k = 2:length( res_tags );
    linker.residue1 = res_tags{1};
    linker.residue2 = res_tags{k};
    linker.type = 'tertcontact_intradomain';
    linker.linker_tag = sprintf('Linker_%s_%s_%s_%s',linker.residue1(9:end),linker.residue2(9:end),  ...
        contact_name,linker.type);
    linker.tertiary_contact = tag;
    add_linker( linker );
    linkers = [ linkers, linker.linker_tag ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function add_linker( linker )
linker_tag = linker.linker_tag;
add_linker_to_residue( linker.residue1, linker_tag )
add_linker_to_residue( linker.residue2, linker_tag )
if ~isappdata( gca, linker_tag );  setappdata( gca, linker_tag, linker );  end
