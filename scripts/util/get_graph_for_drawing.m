function [g,res_tags] = get_graph_for_drawing( collapse_helix )
% [g,res_tags] = get_graph_for_drawing( collapse_helix )
%
% INPUT:
%   collapse_helix = 0/1 for whether to include edges across all residues
%                       collapsed in the same 'helix'
%
% OUTPUT:
%    g        = graph over residues
%    res_tags = residue names
%
% (C) R. Das, Stanford University 2018

if ~exist( 'collapse_helix' ) collapse_helix = 0; end;
g = graph();
res_tags = get_tags( 'Residue' );
nbrs = [];
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    % look for sequence neighbor
    partner_tag = sanitize_tag(sprintf('Residue_%s%s%d',residue.chain,residue.segid,residue.resnum+1));
    j = find(strcmp( res_tags, partner_tag ));
    if ~isempty( j )
        assert( length( j ) == 1 );
        nbrs = [nbrs; i,j];
    end
    if isfield( residue, 'stem_partner' )
        j = find(strcmp( res_tags, residue.stem_partner ));
        if ~isempty( j )
            assert( length( j ) == 1 );
            nbrs = [nbrs; i,j];
        end
    end
end

if collapse_helix
    helix_tags = get_tags( 'Helix' );
    for i = 1:length( helix_tags )
        helix = getappdata( gca, helix_tags{i} );
        helix_res = helix.associated_residues();
        for j = 1:length( helix_res )
            for k = j+1:length( helix_res )
                nbrs = [ nbrs; find(strcmp( res_tags,helix_res(j))), find(strcmp( res_tags,helix_res(k))) ];
            end
        end
    end
end

nbrs = unique(sort(nbrs,2),'rows');
g = graph(nbrs(:,1),nbrs(:,2),[],res_tags);
