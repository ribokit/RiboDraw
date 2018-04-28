function linker_groups = group_linkers_for_tertiary_contacts( domain_names )
% linker_groups = group_linkers_for_tertiary_contacts( domain_names )
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
%
% Output:
%  linker_groups = cell of cells of linker tags that were grouped. 
%
%
% (C) R. Das, Stanford University 2017-2018

linker_groups = {};
if ~exist( 'domain_names', 'var' ) | ~iscell( domain_names ) | length( domain_names ) < 2;
    fprintf( 'Provide at least two domain names' ); return;
end

% get interdomain_linkers
linkers = {};
% order of preference
interdomain_linker_types = get_interdomain_linker_types();
for i = 1:length( interdomain_linker_types )
    linkers = [ linkers; get_tags( 'Linker', interdomain_linker_types{i} ) ];
end

% Clear domain information from any linkers that are not on this list
other_linkers = setdiff( get_tags( 'Linker' ), linkers );
for i = 1:length( other_linkers );  rmdomainfields( getappdata(gca,other_linkers{i}) );  end

interdomain_linkers = assign_linker_domains( domain_names, linkers );

linker_groups = group_linkers( interdomain_linkers );



