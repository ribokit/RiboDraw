function interdomain_linkers = assign_linker_domains( domain_names, linkers )
% interdomain_linkers = assign_linker_domains( linkers, domain_names )
%
% Note that the domain information is saved domain1 and domain2 fields of linker objects
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
[domain_tags,ok] = get_gca_domain_tags( domain_names );
if ~exist( 'linkers','var' ) linkers = get_tags( 'Linker' ); end;

if ~ok; 
    fprintf( 'Problem in assign_linker_domains\n' ); return; 
end;

tic
fprintf( 'Assigning linker domains...\n' );
for i = 1:length( linkers );
    linker = getappdata( gca, linkers{i} );
    domain_member1 = get_domain_membership( linker.residue1, domain_tags );
    domain_member2 = get_domain_membership( linker.residue2, domain_tags );

    % the two residues should not be part of the same domain.
    if any( domain_member1 ) && any( domain_member2 ) && ~any( domain_member1 .* domain_member2 ) 
        %if linker_connects_different_domains( residue1, residue2 )
        domains1 = domain_tags(find(domain_member1));
        linker.domain1 = domains1{1}; % first one.
        domains2 = domain_tags(find(domain_member2));
        linker.domain2 = domains2{1}; % first one.
        linker.interdomain = 1;
        interdomain_linkers = [ interdomain_linkers, linker ];
        setappdata( gca, linker.linker_tag, linker );
    else
        linker = rmdomainfields( linker );
    end    
end
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function domain_member = get_domain_membership( res_tag, domain_tags );
domain_member = zeros( 1, length( domain_tags ) );
residue = getappdata( gca, res_tag );
if ~isfield( residue, 'associated_selections' ); return; end;

for i = 1:length( domain_tags )
    domain_member(i) = any( strcmp( residue.associated_selections, domain_tags{i} ) ) || strcmp(residue.res_tag,domain_tags{i});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [domain_tags,ok] = get_gca_domain_tags( domain_names );
ok = 1;
domain_tags = {};
for i = 1:length( domain_names )
    domain_tags{i} = get_domain_tag( domain_names{i} );
    if length( domain_tags{i} ) == 0;
        fprintf( 'Could not find domain tag for : %s\n', domain_names{i} );
        ok = 0; break;
    end;
end


