function remove_residues_from_domain( residue_string, name );
% remove_residues_from_domain( residue_string, domain_name );
%
% Removes residues from pre-existing domain.
%
% INPUTS
%   residue_string = string like 'A:QA:1-5', or residue tags, or cell of those.
%   name           =  name or tag for domain
%
% See also: ADD_RESIDUES_TO_DOMAIN, SETUP_DOMAIN.
%
% (C) Rhiju Das, Stanford University, 2017

domain_tag = get_domain_tag( name );
remove_res_tags = get_res( residue_string );

if ~isappdata( gca, domain_tag ) return; end;

domain = getappdata(gca , domain_tag);
associated_residues = domain.associated_residues;
associated_helices  = {};
for i = 1:length( associated_residues );
    residue = getappdata( gca, associated_residues{i} );
    if any( strcmp( residue.res_tag, remove_res_tags ) )
        fprintf( 'Removing %s from %s\n', residue.res_tag, domain_tag );
        residue.associated_selections = setdiff( residue.associated_selections, domain_tag );
        associated_helices = [ associated_helices, residue.helix_tag ];
        setappdata( gca, associated_residues{i}, residue );
        domain.associated_residues = setdiff( domain.associated_residues, associated_residues{i} );
    end
    setappdata( gca, domain_tag, domain );
end

draw_selections( domain_tag );


