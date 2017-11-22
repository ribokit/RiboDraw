function relpos = get_relpos( plot_pos, helix )
% relpos = get_relpos( plot_pos, helix )
%
% Helper function for redrawing labels and nucleotides relative to helix
%
% Input:
%  plot_pos = Plot position (x,y) of element on drawing.
%  helix    = Helix object that defines a local coordinate frame for element
%
% Output
%  relpos   = Local coordinates of element in frame of helix (defined by the helix center & rotation)
%
% (C) R. Das, Stanford University, 2017

R = get_helix_rotation_matrix( helix );
relpos = (plot_pos - repmat(helix.center,size(plot_pos,1),1))*R';
