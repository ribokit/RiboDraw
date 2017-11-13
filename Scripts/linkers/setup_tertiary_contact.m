function tertiary_contact = setup_tertiary_contact( contact_name, res1_string, res2_string, template_linker, skip_move_stuff_to_back, print_stuff )
% setup_tertiary_contact( contact_name, res_tags1, res_tags2)
% setup_tertiary_contact( contact_name, res1_string, res2_string )
% (C) R. Das, Stanford University, 2017
if iscell( res1_string ) & iscell( res2_string )
    res_tags1 = res1_string;
    res_tags2 = res2_string;
else
    res_tags1 = get_res_tags( res1_string );
    res_tags2 = get_res_tags( res2_string );
end

if length( res_tags1 ) == 0; return; end;
if length( res_tags2 ) == 0; return; end;

if length(contact_name) == 0
    default_name = 1;
    residue1 = getappdata( gca, res_tags1{1} );
    residue2 = getappdata( gca, res_tags2{1}  );
    contact_name = sprintf( '%s%s%d_%s%s%d',  residue1.chain,residue1.segid,residue1.resnum, residue2.chain,residue2.segid,residue2.resnum  );
else
    default_name = 0;
end
if ~exist( 'print_stuff' ) print_stuff = 1; end;
    
if ~isempty( intersect( res_tags1, res_tags2 ) )
    tag = '';
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
if isappdata( gca, linker.linker_tag ) & isappdata( gca, tag )
    prev_tertiary_contact = getappdata( gca, tag );
    if isequal( prev_tertiary_contact.associated_residues1, tertiary_contact.associated_residues1 ) & ...
            isequal( prev_tertiary_contact.associated_residues2, tertiary_contact.associated_residues2 )
        fprintf( 'Already set up %s so not creating again.\n', linker.linker_tag );
        return;
    else
        template_linker = getappdata( gca, prev_tertiary_contact.interdomain_linker );
        delete_tertiary_contact( tag );
    end
else
    if print_stuff; fprintf( 'Setting up %s.\n', linker.linker_tag ); end;
end

if exist( 'template_linker', 'var' )
    if isfield( template_linker, 'relpos1' )  linker.relpos1 = template_linker.relpos1; end;
    if isfield( template_linker, 'relpos2' )  linker.relpos2 = template_linker.relpos2; end;
    if isfield( template_linker, 'plot_pos' ) linker.plot_pos = template_linker.plot_pos; end;
    linker = create_linker_with_draggable_vtx( linker );
end
add_linker( linker );
tertiary_contact.interdomain_linker = linker.linker_tag;

tertiary_contact.intradomain_linkers1 = setup_intradomain_linkers( res_tags1, contact_name_cleaned, tag );
tertiary_contact.intradomain_linkers2 = setup_intradomain_linkers( res_tags2, contact_name_cleaned, tag );
setappdata( gca, tag, tertiary_contact );
if default_name; update_tertiary_contact_names( {tag}, print_stuff ); end;

% draw these linkers
draw_linker( [{tertiary_contact.interdomain_linker},tertiary_contact.intradomain_linkers1,tertiary_contact.intradomain_linkers2] );
% res_tags = [res_tags1, res_tags2 ]; 
% helix_tags = {};
% for i = 1:length( res_tags );
%     residue = getappdata( gca, res_tags{i});
%     helix_tags = [ helix_tags, residue.helix_tag ];
% end
% helix_tags = unique( helix_tags );
% for i = 1:length( helix_tags ); draw_helix( getappdata( gca, helix_tags{i} ) ); end

if ~exist( 'skip_move_stuff_to_back','var') skip_move_stuff_to_back = 0; end;
if ~skip_move_stuff_to_back 
    tic
    move_stuff_to_back(); % should be faster to move all tertiary contact linkers to 'back' all at once
    toc
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function linkers = setup_intradomain_linkers( res_tags, contact_name, tag );
linkers = {};
if length( res_tags ) == 1; return; end;

% setup network of intradomain linkers based on minimum spanning tree --
% will be easier on the eyes than web to a random point.
for i = 1:length( res_tags );
    residues{i} = getappdata( gca, res_tags{i} );
end
s = [];
t = [];
weights = [];
for i = 1:length( res_tags );
    for j = i+1:length( res_tags );
        s = [s,i];
        t = [t,j];
        weights = [ weights, norm( residues{i}.plot_pos - residues{j}.plot_pos ) ];
    end
end
G = graph( s, t, weights );
[T,predecessor] = minspantree( G, 'Root',findnode(G,1) );
assert( numedges(T) == length(res_tags) - 1);

res_tags2 = {};
for k = 1:numedges(T);
    [i,j] = findedge(T,k);
    if ( predecessor(j) ~= i )
        x = i; i = j; j = x;
    end
    assert( predecessor(j) == i );
    linker.residue1 = res_tags{i};
    linker.residue2 = res_tags{j};
    res_tags2 = [ res_tags2, linker.residue2];
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
