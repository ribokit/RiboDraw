function cleanup_associated_residues()
helix_tags = get_tags( 'Helix_' );

for k = 1:length( helix_tags )
    associated_res{k} = {};
end

res_tags = get_tags( 'Residue_' );
for i = 1:length( res_tags )
    res_tag = res_tags{i};
    residue = getappdata( gca, res_tag );
    if ~isfield( residue, 'helix_tag' ) 
        % weird thing that seems to happen, residue with just linkers
        rmappdata( gca, res_tag );
        continue;
    end
    assert( any( strcmp( helix_tags, residue.helix_tag ) ) );
    k = find(  strcmp( helix_tags, residue.helix_tag ) );
    associated_res{k} = [associated_res{k}, res_tag ];
end

for k = 1:length( helix_tags )
    helix = getappdata( gca, helix_tags{k} );
    helix.associated_residues = associated_res{k};
    setappdata( gca, helix_tags{k}, helix );
end


