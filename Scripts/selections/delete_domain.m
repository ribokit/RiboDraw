function setup_domain( name );
% setup_domain( residue_string, name );
% (C) Rhiju Das, Stanford University, 2017

delete_tag = sprintf('Selection_%s', strrep(name, ' ', '_' ) );
if ~isappdata( gca, delete_tag );
    delete_tag = name;
    if ~isappdata( gca, delete_tag ) 
        fprintf( 'Could not find domain with name: %s\n', name );
    end
end

domain = getappdata( gca, delete_tag );

for j = 1:length( domain.associated_residues )
    residue_tag = domain.associated_residues{j};
    residue = getappdata( gca, residue_tag );
    if ~isfield( residue, 'associated_selections' )
        residue.associated_selections = {};
    end
    residue.associated_selections = setdiff( residue.associated_selections, delete_tag );
    setappdata( gca, residue_tag, residue );
end

if isfield( domain,'label' ); delete( domain.label ); end;
if isfield( domain,'rectangle' ); delete( domain.rectangle ); end;
rmappdata( gca, delete_tag );

