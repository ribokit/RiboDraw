function linker_groups = group_linkers( linkers, domain_assignments )
% linker_groups = group_linkers( linkers )
%
%  Find clusters of linkers that are close in sequence and
%     interconnect the same domains.
%
% Only groups two linkers that connect the same domains
%   (as defined by the user in the linker.domain1 and linker.domain2 input variables)
%  or that involve the same ligand.
%
% Input:
%  linkers  = cell of linkers to group. 
%
% Output:
%  linker_groups = cell of cells of linker tags that were grouped.  Residue1 and Residue2 will be
%             switched for each linker to match order of domains in
%             'parent' linker of linker_group.
%
%
% (C) R. Das, Stanford University

linker_groups = {};

fprintf( 'Grouping linkers...\n' );
tic
% now group by domain.
linker_groups = {};
nbrs = [];
[g,res_tags] = get_graph_for_drawing( 1 );
D = distances(g);
for i = 1:length( linkers )
    linker_i = linkers{i};
    domain_assignment_i = domain_assignments{i};
    for j = (i+1):length( linkers )
        linker_j = linkers{j};
        domain_assignment_j = domain_assignments{j};
        % look for match of domain and closeness of sequence
        if ( strcmp( domain_assignment_i{1}, domain_assignment_j{1} ) && ...
             strcmp( domain_assignment_i{2}, domain_assignment_j{2}  ) && ...
             check_distance_close( D, res_tags, linker_i.residue1, linker_j.residue1 ) && ...
             check_distance_close( D, res_tags, linker_i.residue2, linker_j.residue2 ) )
            nbrs = [nbrs; i,j];
        elseif (strcmp( domain_assignment_i{1}, domain_assignment_j{2} ) && ...
                strcmp( domain_assignment_i{2}, domain_assignment_j{1}  ) && ...
                check_distance_close( D, res_tags, linker_i.residue1, linker_j.residue2 ) && ...
                check_distance_close( D, res_tags, linker_i.residue2, linker_j.residue1 ) )
            nbrs = [nbrs; i,j];
        end
    end
end
toc

if isempty( nbrs); return; end;
g_linker = graph(nbrs(:,1),nbrs(:,2));
bins = conncomp( g_linker );

for n = 1:max(bins)
    linker_group = {};
    idx = find( bins == n );
    for i = idx;
        % need to reorder residues in linkers to match 'parent' of linker group.
        linker = linkers{i};
        if ~strcmp(domain_assignments{i}{1},domain_assignments{idx(1)}{1} )
            assert( strcmp(domain_assignments{i}{1},domain_assignments{idx(1)}{2} ) );
            assert( strcmp(domain_assignments{i}{2},domain_assignments{idx(1)}{1} ) );
            res1 = linker.residue1;
            res2 = linker.residue2;
            linker.residue1 = res2;
            linker.residue2 = res1;
        end
        linker_group = [linker_group, linker ];
    end
    linker_groups{i} = linker_group;
end

% get rid of any linker groups that are all stacks...
linker_groups = filter_groups_without_pairs( linker_groups );

% 
% % allows quick check by eye...
% for i = 1:length( linker_groups )
%     color = rand(3,1);
%     linker_group = linker_groups{i};
%     for j = 1:length( linker_group )
%         linker = linker_group{j};
%         if isfield( linker, 'line_handle' ) set( linker.line_handle, 'color', color ); end;
%     end
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% deprecated in favor of check_distance_close
function match = check_sequence_close( residue, other_res ) 
% now look for closeness, based on all residues in parent helix.
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
% deprecated in favor of check_distance_close
function match = check_graph_close( g, res_tags, res_tag1, res_tag2 );
[P,d] = shortestpath(g,find(strcmp(res_tags,res_tag1)),find(strcmp(res_tags,res_tag2)));
match = ( d <= 5 );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function match = check_distance_close( D, res_tags, res_tag1, res_tag2 );
d = D(find(strcmp(res_tags,res_tag1)),find(strcmp(res_tags,res_tag2)));
match = ( d <= 5 );

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


