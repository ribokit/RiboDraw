function tertiary_contact_tags = setup_interdomain_tertiary_contacts( domain_names, separate_out_ligands, group_other_residues )
%  tertiary_contact_tags = setup_interdomain_tertiary_contacts( domain_names, separate_out_ligands, group_other_residues )
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
%
% Input:
%  domain_names  = cell of strings with names of domains (previously must have been defined by user
%                  with SETUP_DOMAIN). Example: {'Peptidyl Transferase Center','Domain IV',...}
%                  Default is {}, i.e. just look at ligands connecting to
%                  RNA (as other residues).
%  separate_out_ligands  = ligands/proteins are separate domains (default 1)
%  group_other_residues  = anything not in ligands or input domain_names are grouped into a single 'other' domain (default 1)
%
% Output:
%  tertiary_contact_tags = tags for all new tertiary contacts formed.
%
% See also SETUP_LIGAND_TERTIARY_CONTACTS
%
% (C) R. Das, Stanford University 2017-2018
if ~exist( 'domain_names', 'var' ) domain_names = {}; end;
if ~exist( 'separate_out_ligands', 'var' ) separate_out_ligands = 1; end;
if ~exist( 'group_other_residues', 'var' ) group_other_residues = 1; end;
linker_groups = group_linkers_for_tertiary_contacts( domain_names, separate_out_ligands, group_other_residues );
tertiary_contact_tags = setup_tertiary_contacts_from_linker_groups( linker_groups );

