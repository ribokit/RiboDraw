function plot_pos = get_plot_pos( res_tag, relpos );
if ischar( res_tag ) 
    residue = getappdata( gca, res_tag );
else
    residue = res_tag;
end
helix = getappdata( gca, residue.helix_tag );
R = get_helix_rotation_matrix( helix );
plot_pos = repmat(helix.center,size(relpos,1),1) + relpos*R;
