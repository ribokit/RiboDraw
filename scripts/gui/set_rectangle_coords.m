function set_rectangle_coords( obj, minpos, maxpos, spacing )
% set_rectangle_coords( obj, minpos, maxpos, spacing )
%
%  utility function to create a bounding box based on 2D coordinates minpos & maxpos 
%    that give the minimum and maximum positions of residues in a selection or helix.
%
% (C) R. Das, Stanford University, 2017

set( obj.rectangle, 'Position',...
    [minpos(1) minpos(2) maxpos(1)-minpos(1) maxpos(2)-minpos(2) ]+...
    [-0.5 -0.5 1 1]*0.75*spacing );
