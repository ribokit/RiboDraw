function linker_groups = group_linkers( linkers )
% linker_groups = group_linkers( linkers )
%
% 
%
% Only groups two linkers that connect the same domains
%   (as defined by the user in the linker.domain1 and linker.domain2 input variables)
%  or that involve the same ligand.
%
% Input:
%  linkers  = cell of linkers to group (either all ligands, or previously defined by user
%                  with ASSIGN_LINKER_DOMAINS). 
% Output:
%  linker_groups = cell of cells of linker tags that were grouped. 
%
%
% (C) R. Das, Stanford University

linker_groups = {};


fprintf( 'Grouping linkers...\n' );
tic
% now group by domain.
linker_groups = {};
for i = 1:length( linkers )
    linker = linkers{i};
    match = 0; switch_res = 0;
    residue1 = getappdata( gca, linker.residue1 );
    residue2 = getappdata( gca, linker.residue2 );
    for j = 1:length( linker_groups )
        % look for match of domain
        if ( strcmp( linker.domain1, linker_groups{j}{1}.domain1 ) && ...
                strcmp( linker.domain2, linker_groups{j}{1}.domain2 ) )
            if ( check_sequence_close( residue1, linker_groups{j}{1}.residue1 ) && ...
                    check_sequence_close( residue2, linker_groups{j}{1}.residue2 ) )
                match = j; switch_res = 0; break;
            end
        end
        if ( strcmp( linker.domain1, linker_groups{j}{1}.domain2 ) && ...
                strcmp( linker.domain2, linker_groups{j}{1}.domain1 ) )
            if ( check_sequence_close( residue1, linker_groups{j}{1}.residue2 ) && ...
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
        % start a new linker group
        linker_groups = [ linker_groups, {{linker}} ];
    end
end
toc

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function match = check_sequence_close( residue, other_res_tag ) 
% now look for closeness, based on all residues in parent helix.
other_res = getappdata( gca, other_res_tag );
helix = getappdata( gca, other_res.helix_tag );
match = 0;
for k = 1:length( helix.associated_residues )
    other_helix_res = getappdata( gca, helix.associated_residues{k} );
    if strcmp( other_helix_res.chain, residue.chain ) && ...
            strcmp( other_helix_res.segid, residue.segid ) && ...
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


