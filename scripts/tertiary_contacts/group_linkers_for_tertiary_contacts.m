function [linker_groups, interdomain_linkers] = group_linkers_for_tertiary_contacts( domain_names, separate_out_ligands, group_other_residues )
% linker_groups = group_linkers_for_tertiary_contacts( domain_names, separate_out_ligands, group_other_residues )
%
%  Main function for cleaning up multidomain drawings at 
%   the scale of the ribosome.
%
%  Looks up noncanonical pairs (and other linkers) that are in different domains,
%   (as defined by the user in the domain_names input variable).
%
%  Hides those noncanonical pairs and instead shows intradomain connections and a single
%   interdomain connection with colors reflecting the domains. 
%
%  The information for each group is saved in a TertiaryContact object
%   well as domain1 and domain2 fields of linker objects
%
% Input:
%  domain_names  = cell of strings with names of domains (previously must have been defined by user
%                  with SETUP_DOMAIN). Example: {'Peptidyl Transferase Center','Domain IV',...}
%  separate_out_ligands  = ligands/proteins are separate domains (default 1)
%  group_other_residues  = anything not in ligands or input domain_names are grouped into a single 'other' domain (default 1)
%
% Output:
%  linker_groups = cell of cells of linker tags that were grouped. 
%
%
% (C) R. Das, Stanford University 2017-2018

linker_groups = {};

% get interdomain_linkers -- order of preference
linker_types_for_tertiary_contacts = get_linker_types_for_tertiary_contacts();
linkers = {};
for i = 1:length( linker_types_for_tertiary_contacts )
    linkers = [ linkers; get_tags( 'Linker', linker_types_for_tertiary_contacts{i} ) ];
end

[domain_residue_sets, domain_names] = get_domain_residue_sets( domain_names, separate_out_ligands, group_other_residues );

[interdomain_linkers, domain_assignments] = assign_linker_domains( linkers, domain_names, domain_residue_sets );

linker_groups = group_linkers( interdomain_linkers, domain_assignments );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [domain_residue_sets,domain_names] = get_domain_residue_sets( domain_names, separate_out_ligands, group_other_residues )
domain_residue_sets = {};
if separate_out_ligands  % add ligands as possible domains
    ligand_tags = get_ligand_tags();
    domain_names = union( domain_names,ligand_tags );
end

for i = 1:length( domain_names )
    domain_residue_set  = get_res( domain_names{i} );
    if isempty( domain_residue_set ) fprintf( 'Problem finding residues for %s\n', domain_names{i} ); return;  end;
    domain_residue_sets{i} = domain_residue_set;
    if separate_out_ligands && ~any(strcmp(ligand_tags, domain_names{i})) % if this domain is not a ligand, get rid of any ligand residues
        domain_residue_sets{i} = setdiff( domain_residue_set, ligand_tags );
    end
end

if group_other_residues
    res_in_domains = {};
    N = length( domain_residue_sets );
    for i = 1:N
        res_in_domains = unique( [res_in_domains, domain_residue_sets{i}] );
    end    
    % collect any other residues in drawing into 'other' domain.
    domain_residue_sets{N+1} =  setdiff( get_res( 'all' ), res_in_domains );
    domain_names{N+1}        = 'other';
end




