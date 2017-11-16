function interdomain_linkers = get_interdomain_linkers( linkers, domain_names )
% interdomain_linkers = get_interdomain_linkers( linkers, domain_names )

interdomain_linkers = {};
[domain_tags,ok] = get_gca_domain_tags( domain_names );
if ~ok; return; end;

for i = 1:length( linkers )
    linker = getappdata( gca, linkers{i} );
    domain_member1 = get_domain_membership( linker.residue1, domain_tags );
    domain_member2 = get_domain_membership( linker.residue2, domain_tags );

    if ~any( domain_member1 ) continue; end;
    if ~any( domain_member2 ) continue; end;
    
    % the two residues should not be part of the same domain.
    if any( domain_member1 .* domain_member2 ) continue; end;
    %if linker_connects_different_domains( residue1, residue2 )
    domains1 = domain_tags(find(domain_member1));
    linker.domain1 = domains1{1}; % first one.
    domains2 = domain_tags(find(domain_member2));
    linker.domain2 = domains2{1}; % first one.
    linker.interdomain = 1;
    setappdata( gca, linker.linker_tag, linker );
    interdomain_linkers = [ interdomain_linkers, linker ];    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function domain_member = get_domain_membership( res_tag, domain_tags );
domain_member = zeros( 1, length( domain_tags ) );
residue = getappdata( gca, res_tag );
if ~isfield( residue, 'associated_selections' ); return; end;

for i = 1:length( domain_tags )
    domain_member(i) = any( strcmp( residue.associated_selections, domain_tags{i} ) );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [domain_tags,ok] = get_gca_domain_tags( domain_names );
ok = 1;
domain_tags = {};
for i = 1:length( domain_names )
    domain_tags{i} = get_domain_tag( domain_names{i} );
    if length( domain_tags{i} ) == 0;
        ok = 0; break;
    end;
end


