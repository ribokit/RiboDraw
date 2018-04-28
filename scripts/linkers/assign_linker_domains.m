function [interdomain_linkers, domain_assignments ] = assign_linker_domains( linkers, domain_names, domain_residue_sets )
% [interdomain_linkers, domain_assignments ] = assign_linker_domains( domain_residue_sets, linkers )
%
% Go through linkers and find ones that connect one domain to a different
% domain.
%  
% Inputs:
%  linkers       = cell of linker tags to go through and filter for interdomain.
%  domain_names  = cell of strings with names of domains (previously must have been defined by user
%                  with SETUP_DOMAIN). Example: {'Peptidyl Transferase Center','Domain IV',...}
%
% Outputs:
%  interdomain_linkers = filtered cell of linker tags that interconnect different domains.
%
%
% (C) R. Das, Stanford University, 2018

interdomain_linkers = {};
domain_assignments = {};
tic
fprintf( 'Assigning linker domains...\n' );
for i = 1:length( linkers );
    linker = getappdata( gca, linkers{i} );
    domain_member1 = get_domain_membership( linker.residue1, domain_residue_sets );
    domain_member2 = get_domain_membership( linker.residue2, domain_residue_sets );

    % the two residues should not be part of the same domain.
    if any( domain_member1 ) && any( domain_member2 ) && ~any( domain_member1 .* domain_member2 ) 
        assert( sum( domain_member1 ) == 1 );
        assert( sum( domain_member2 ) == 1 );
        interdomain_linkers = [ interdomain_linkers, linker ];
        domain_assignments  = [ domain_assignments, { {domain_names{find(domain_member1)},domain_names{find(domain_member2)}} } ];
    end
end
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function domain_member = get_domain_membership( res_tag, domain_residue_sets );
domain_member = zeros( 1, length( domain_residue_sets ) );
for i = 1:length( domain_residue_sets )
    domain_member(i) = any( strcmp( domain_residue_sets{i}, res_tag ) );
end



