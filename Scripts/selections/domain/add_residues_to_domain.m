function add_residues_to_domain( residue_string, name );
% add_residues_from_domain( residue_string, domainn_name );
% (C) Rhiju Das, Stanford University, 2017

domain_tag = get_domain_tag( name );
add_res_tags = get_res( residue_string );

if ~isappdata( gca, domain_tag ) return; end;
if isempty( add_res_tags) return; end;

domain = getappdata(gca , domain_tag);
domain.associated_residues = unique( [domain.associated_residues, add_res_tags] );
setappdata( gca, domain_tag, domain );

for i = 1:length( add_res_tags );
    res_tag = add_res_tags{i};
    residue = getappdata( gca, res_tag );
    fprintf( 'Add %s to %s\n', residue.res_tag, domain_tag );
    if ~isfield( residue, 'associated_selections' ) residue.associated_selections = {}; end;
    residue.associated_selections = unique( [residue.associated_selections, domain_tag] );
    setappdata( gca, res_tag, residue );
end

draw_selections( domain_tag );



