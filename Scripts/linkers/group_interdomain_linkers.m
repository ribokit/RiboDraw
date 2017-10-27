function linker_groups = group_interdomain_linkers()

% get interdomain_linkers
linkers = get_tags( 'Linker', 'noncanonical_pair' );
%linkers = [ linkers, get_tags( 'Linker', 'stack' ) ];

interdomain_linkers = {};
for i = 1:length( linkers )
    linker = getappdata( gca, linkers{i} );
    residue1 = getappdata( gca, linker.residue1 );
    residue2 = getappdata( gca, linker.residue2 );
    % check that there are two different (non-gray) colors
    if isfield( residue1, 'rgb_color' ) & isfield( residue2, 'rgb_color' ) & ...
            length(unique( residue1.rgb_color)) > 1 & ...
            length(unique( residue2.rgb_color)) > 1 &  ...
            norm( residue1.rgb_color - residue2.rgb_color ) >= 0.1
        linker.color1 = residue1.rgb_color;
        linker.color2 = residue2.rgb_color;
        interdomain_linkers = [ interdomain_linkers, linker ];
    end
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
        if ( all( linker.color1 == linker_groups{j}{1}.color1 ) & ...
                all( linker.color2 == linker_groups{j}{1}.color2 ) )
            if ( check_sequence_close( residue1, linker_groups{j}{1}.residue1 ) & ...
                    check_sequence_close( residue2, linker_groups{j}{1}.residue2 ) )
                match = j; switch_res = 0; break;
            end
        end
        if ( all( linker.color1 == linker_groups{j}{1}.color2 ) & ...
                all( linker.color2 == linker_groups{j}{1}.color1 ) )
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
linker_groups = linker_groups_filter;

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
    res_tags1 = {};
    res_tags2 = {};
    linker_lengths = [];
    for j = 1:length( linker_group )
        linker = linker_group{j};
        res_tags1 = [res_tags1, linker.residue1 ];
        res_tags2 = [res_tags2, linker.residue2 ];
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
        linker_lengths(j) = linker_length;
    end
    [~, idx ] = min( linker_lengths );
    main_linker = linker_group{idx};
    
    % get all residues involved in tertiary contact.
    residue1 = getappdata( gca, main_linker.residue1 );
    residue2 = getappdata( gca, main_linker.residue2 );
    name = sprintf( '%s%d_%s%d',  residue1.chain,residue1.resnum, residue2.chain, residue2.resnum  );
    res_tags1 = [main_linker.residue1, setdiff( unique( res_tags1 ), main_linker.residue1 ) ];
    res_tags2 = [main_linker.residue2, setdiff( unique( res_tags2 ), main_linker.residue2 ) ];

    setup_tertiary_contact( name, res_tags1, res_tags2, main_linker );
end

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

