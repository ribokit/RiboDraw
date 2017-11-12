function linker_groups = group_interdomain_linkers( domain_names )
% linker_groups = group_interdomain_linkers( domain_names )
linker_groups = {};
if ~exist( 'domain_names', 'var' ) | ~iscell( domain_names ) | length( domain_names ) < 2;
    fprintf( 'Provide at least two domain names' ); return;
end

[domain_tags,ok] = get_gca_domain_tags( domain_names );
if ~ok; return; end;

% get interdomain_linkers
linkers = {};
% order of preference
linker_types = {'noncanonical_pair','ligand','long_range_stem_pair','stack','other_contact'};
for i = 1:length( linker_types )
    linkers = [ linkers, get_tags( 'Linker', linker_types{i} ) ];
end

interdomain_linkers = {};
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


% now group by domain.
linker_groups = {};
for i = 1:length( interdomain_linkers )
    linker = interdomain_linkers{i};
    match = 0; switch_res = 0;
    residue1 = getappdata( gca, linker.residue1 );
    residue2 = getappdata( gca, linker.residue2 );
    for j = 1:length( linker_groups )
        % look for match of domain (as defined by rgb color )
        if ( strcmp( linker.domain1, linker_groups{j}{1}.domain1 ) & ...
                strcmp( linker.domain2, linker_groups{j}{1}.domain2 ) )
            if ( check_sequence_close( residue1, linker_groups{j}{1}.residue1 ) & ...
                    check_sequence_close( residue2, linker_groups{j}{1}.residue2 ) )
                match = j; switch_res = 0; break;
            end
        end
        if ( strcmp( linker.domain1, linker_groups{j}{1}.domain2 ) & ...
                strcmp( linker.domain2, linker_groups{j}{1}.domain1 ) )
            if ( check_sequence_close( residue1, linker_groups{j}{1}.residue2 ) & ...
                    check_sequence_close( residue2, linker_groups{j}{1}.residue1 ) )
                match = j; switch_res = 1; break;
            end
        end
    end
    if match 
        if switch_res
            % used to define associated_residues for tertiary_contacts --
            % see below
            res1 = linker.residue1;
            res2 = linker.residue2;
            linker.residue1 = res2;
            linker.residue2 = res1;
        end
        linker_groups{match} = [ linker_groups{match}, linker ];
    else
        linker_groups = [ linker_groups, {{linker}} ];
    end
end

% get rid of any linker groups that are all stacks...
linker_groups = filter_all_stack_groups( linker_groups );

% allows quick check by eye...
for i = 1:length( linker_groups )
    color = rand(3,1);
    linker_group = linker_groups{i};
    for j = 1:length( linker_group )
        linker = linker_group{j};
        if isfield( linker, 'line_handle' ) set( linker.line_handle, 'color', color ); end;
    end
end

% let's try to set up a tertiary contact
for i = 1:length( linker_groups )
    linker_group = linker_groups{i};

    % need to assign a pair of interdomain connection residues.
    [res_tags1, res_tags2 ] = get_res_tags( linker_group );
    main_linker = look_for_previous_tertiary_contact( res_tags1, res_tags2 );
    if isempty( main_linker ) main_linker = find_shortest_possible_linker( linker_group, linker_types ); end;
            
    % get all residues involved in tertiary contact.
    residue1 = getappdata( gca, main_linker.residue1 );
    residue2 = getappdata( gca, main_linker.residue2 );
    res_tags1 = [main_linker.residue1, setdiff( unique( res_tags1 ), main_linker.residue1 ) ];
    res_tags2 = [main_linker.residue2, setdiff( unique( res_tags2 ), main_linker.residue2 ) ];

    tertiary_contact_tag = setup_tertiary_contact( '', res_tags1, res_tags2, main_linker, 1 );
end

hide_interdomain_noncanonical_pairs;
hide_ligand_linkers;
move_stuff_to_back;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function match = check_sequence_close( residue, other_res_tag ) 
% now look for closeness, based on all residues in parent helix.
other_res = getappdata( gca, other_res_tag );
helix = getappdata( gca, other_res.helix_tag );
match = 0;
for k = 1:length( helix.associated_residues )
    other_helix_res = getappdata( gca, helix.associated_residues{k} );
    if strcmp( other_helix_res.chain, residue.chain ) & ...
            abs( other_helix_res.resnum - residue.resnum ) <= 5
        match = 1; return;
    end
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
all_domain_tags = get_tags( 'Selection','domain' );
ok = 0;
domain_tags = {};
for i = 1:length( domain_names )
    found_it = 0;
    for j = 1:length( all_domain_tags )
        if strcmp( all_domain_tags{j}, domain_names{i} );
            found_it = 1; doman_tags{i} = all_domain_tags{j}; break;            
        else
            domain = getappdata( gca, all_domain_tags{j} );
            if strcmp( domain.name, domain_names{i} )
                domain_tags{i} = all_domain_tags{j};
                found_it = 1; doman_tags{i} = all_domain_tags{j}; break;
            end
        end
    end
    if ~found_it
        fprintf( 'Could not figure out domain for %s\n', domain_names{i} );
        return;
    end
end
ok = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function linker_groups_filter = filter_all_stack_groups( linker_groups );
linker_groups_filter = {};
for i = 1:length( linker_groups )
    linker_group = linker_groups{i};
    ok = 0;
    for j = 1:length( linker_group )
        linker = linker_group{j};
        if ~strcmp( linker.type, 'stack' )
            ok = 1;
            break;
        end
    end
    if ok
        linker_groups_filter = [ linker_groups_filter, {linker_group} ];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [res_tags1,res_tags2] = get_res_tags( linker_group );
res_tags1 = {};
res_tags2 = {};
for j = 1:length( linker_group )
    linker = linker_group{j};
    res_tags1 = [res_tags1, linker.residue1 ];
    res_tags2 = [res_tags2, linker.residue2 ];
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main_linker = find_shortest_possible_linker( linker_group, linker_types );
linker_lengths = [];
for j = 1:length( linker_group )
    linker = linker_group{j};
    linker_length = 0;
    if isfield( linker, 'plot_pos' )
        for i = 1:size( linker.plot_pos, 1 )-1
            linker_length = linker_length + norm( linker.plot_pos( i, : ) - linker.plot_pos( i+1, : ) );
        end
    else
        res1 = getappdata( gca, linker.residue1 );
        res2 = getappdata( gca, linker.residue2 );
        linker_length = norm( res1.plot_pos - res2.plot_pos );
    end
    linker_lengths(j,:) = [find(strcmp(linker.type, linker_types)), linker_length];
end
[~, idx ] = sortrows( linker_lengths );
main_linker = linker_group{idx};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main_linker = look_for_previous_tertiary_contact( res_tags1, res_tags2 );
main_linker = [];
tags = get_tags( 'TertiaryContact' );
for i = 1:length( tags )
    tertiary_contact = getappdata( gca, tags{i} );
    if ( any(strcmp(tertiary_contact.associated_residues1{1},res_tags1 )) & ...
            any(strcmp(tertiary_contact.associated_residues2{1},res_tags2 )) )
        fprintf( 'Found template linker from tertiary contact %s\n',  tags{i} );
        main_linker = getappdata( gca, tertiary_contact.interdomain_linker );
        return;
    elseif ( any(strcmp(tertiary_contact.associated_residues2{1},res_tags1 )) & ...
            any(strcmp(tertiary_contact.associated_residues1{1},res_tags2 ))   )
        fprintf( 'Found template linker from tertiary contact %s\n',  tags{i} );
        main_linker = getappdata( gca, tertiary_contact.interdomain_linker );
        res1 = main_linker.residue1;
        res2 = main_linker.residue2;
        main_linker.residue1 = res2;
        main_linker.residue2 = res1;
        return;
    end
end

