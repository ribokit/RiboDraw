function setup_tertiary_contact( contact_name, res1_string, res2_string, template_linker )
% setup_tertiary_contact( contact_name, res_tags1, res_tags2)
% setup_tertiary_contact( contact_name, res1_string, res2_string )
% (C) R. Das, Stanford University, 2017

res_tags1 = get_res_tags( res1_string );
res_tags2 = get_res_tags( res2_string );

if length( res_tags1 ) == 0; return; end;
if length( res_tags2 ) == 0; return; end;

if ~isempty( intersect( res_tags1, res_tags2 ) )
    fprintf( 'res_tags1 and res_tags2 have common residues... not creating tertiary contact %s\n', contact_name );
    intersect( res_tags1, res_tags2 );
    return 
end

contact_name_cleaned = strrep( strrep(contact_name, ' ', '_' ), '-', '_' ) ;
tag = sprintf('TertiaryContact_%s', contact_name_cleaned );
tertiary_contact.associated_residues1 = res_tags1;
tertiary_contact.associated_residues2 = res_tags2;
tertiary_contact.name = contact_name;
tertiary_contact.tertiary_contact_tag = tag;

% interdomain connector.
linker.residue1 = res_tags1{1};
linker.residue2 = res_tags2{1};
linker.type = 'tertcontact_interdomain';
linker.linker_tag = sprintf('Linker_%s_%s_%s_%s',linker.residue1(9:end),linker.residue2(9:end),  ...
    contact_name_cleaned,linker.type);
linker.tertiary_contact = tag;
if exist( 'template_linker', 'var' )
    if isfield( template_linker, 'relpos1' ) linker.relpos1 = template_linker.relpos1; end;
    if isfield( template_linker, 'relpos2' ) linker.relpos2 = template_linker.relpos2; end;
    if isfield( template_linker, 'plot_pos' ) linker.plot_pos = template_linker.plot_pos; end;
    create_linker_with_draggable_vtx( linker )
end
add_linker( linker );
tertiary_contact.interdomain_linker = linker.linker_tag;

tertiary_contact.intradomain_linkers1 = setup_intradomain_linkers( res_tags1, contact_name_cleaned, tag );
tertiary_contact.intradomain_linkers2 = setup_intradomain_linkers( res_tags2, contact_name_cleaned, tag );
setappdata( gca, tag, tertiary_contact );

% draw these linkers
res_tags = [res_tags1, res_tags2 ]; 
helix_tags = {};
for i = 1:length( res_tags );
    residue = getappdata( gca, res_tags{i});
    helix_tags = [ helix_tags, residue.helix_tag ];
end
helix_tags = unique( helix_tags );
for i = 1:length( helix_tags ); draw_helix( getappdata( gca, helix_tags{i} ) ); end

move_stuff_to_back(); % should be faster to move all tertiary contact linkers to 'back' all at once

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
