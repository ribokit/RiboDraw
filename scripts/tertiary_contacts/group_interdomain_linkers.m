function linker_groups = group_interdomain_linkers( domain_names )
% linker_groups = group_interdomain_linkers( domain_names )
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
%  (The information for each group is saved in a TertiaryContact object.)
%
% TODO: may need to set interdomain field to the grouped linkers to allow
%    them to be properly hidden.
%
% Input:
%  domain_names  = cell of strings with names of domains (previously must have been defined by user
%                  with SETUP_DOMAIN). Example: {'Peptidyl Transferase Center','Domain IV',...}
%
% Output:
%  linker_groups = cell of cells of linker tags that were grouped. 
%
% (C) R. Das, Stanford University

linker_groups = {};
if ~exist( 'domain_names', 'var' ) | ~iscell( domain_names ) | length( domain_names ) < 2;
    fprintf( 'Provide at least two domain names' ); return;
end

% get interdomain_linkers
linkers = {};
% order of preference
linker_types = {'ligand','noncanonical_pair','long_range_stem_pair','stack','other_contact'};
for i = 1:length( linker_types )
    linkers = [ linkers; get_tags( 'Linker', linker_types{i} ) ];
end

interdomain_linkers = get_interdomain_linkers( linkers, domain_names );

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
%     if ~isfield( linker, 'plot_pos' )
%         fprintf( 'Need to figure out where linker is... drawing it temporarily\n' );
%         show_interdomain_noncanonical_pairs;
%         show_ligand_linkers;
%     end
end

% get rid of any linker groups that are all stacks...
linker_groups = filter_groups_without_pairs( linker_groups );

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

    % TODO: May need to tag the associated linkers with 'interdomain' field. But then how to reverse?

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
            strcmp( other_helix_res.segid, residue.segid ) & ...
            abs( other_helix_res.resnum - residue.resnum ) <= 5
        match = 1; return;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function linker_groups_filter = filter_groups_without_pairs( linker_groups );
linker_groups_filter = {};
for i = 1:length( linker_groups )
    linker_group = linker_groups{i};
    ok = 0;
    for j = 1:length( linker_group )
        linker = linker_group{j};
        if any(strcmp( linker.type, {'noncanonical_pair','ligand','long_range_stem_pair'} ) )
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

