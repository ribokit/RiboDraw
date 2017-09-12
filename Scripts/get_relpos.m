function relpos = get_relpos( plot_pos, helix )
R = get_helix_rotation_matrix( helix );
relpos = (plot_pos - repmat(helix.center,size(plot_pos,1),1))*R';
