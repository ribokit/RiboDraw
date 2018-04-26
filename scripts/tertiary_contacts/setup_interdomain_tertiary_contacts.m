function tertiary_contact_tags = setup_interdomain_tertiary_contacts( domain_names )
% setup_interdomain_tertiary_contacts( domain_names )
%
% Example for ligands:
%  setup_interdomain_tertiary_contacts( [{'RNA'},get_ligand_tags()] );
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
%  The information for each group is saved in a TertiaryContact object as
%   well as domain1 and domain2 fields of linker objects
%
% Input:
%  domain_names  = cell of strings with names of domains (previously must have been defined by user
%                  with SETUP_DOMAIN). Example: {'Peptidyl Transferase Center','Domain IV',...}
%
% Output:
%  tertiary_contact_tags = tags for all new tertiary contacts formed.
%
% See also SETUP_LIGAND_TERTIARY_CONTACTS
%
% (C) R. Das, Stanford University 2017-2018

linker_groups = group_interdomain_linkers( domain_names );
tertiary_contact_tags = setup_tertiary_contacts( linker_groups );

