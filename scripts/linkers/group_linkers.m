function linker_groups = group_linkers( linkers )
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
nbrs = [];
for i = 1:length( linkers )
    linker_i = linkers{i};
    residue_i1 = getappdata(gca,linker_i.residue1);
    residue_i2 = getappdata(gca,linker_i.residue2);
    for j = (i+1):length( linkers )
        linker_j = linkers{j};
        residue_j1 = getappdata(gca,linker_j.residue1);
        residue_j2 = getappdata(gca,linker_j.residue2);
        % look for match of domain and closeness of sequence
        if ( strcmp( linker_i.domain1, linker_j.domain1 ) && ...
                strcmp( linker_i.domain2, linker_j.domain2 ) && ...
                check_sequence_close( residue_i1, residue_j1 ) && ...
                check_sequence_close( residue_i2, residue_j2 ) )
            nbrs = [nbrs; i,j];
        elseif ( strcmp( linker_i.domain1, linker_j.domain2 ) && ...
                 strcmp( linker_i.domain2, linker_j.domain1 ) && ...
                check_sequence_close( residue_i1, residue_j2 ) && ...
                check_sequence_close( residue_i2, residue_j1 ) )
            nbrs = [nbrs; i,j];
        end
    end
end
toc

g = graph(nbrs(:,1),nbrs(:,2));
bins = conncomp( g );

for i = 1:max(bins)
    linker_groups{i} = linkers( find( bins == i ) );
end

% get rid of any linker groups that are all stacks...
linker_groups = filter_groups_without_pairs( linker_groups );

% need to reorder residues in linkers to match 'parent' of linker group.


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


