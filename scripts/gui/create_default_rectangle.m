function obj = create_default_rectangle( obj, tag_type, tag, redraw_fcn )
% obj = create_default_rectangle( obj, tag_type, tag, redraw_fcn )
%
%  create a draggable rectangle at a dummy position, used by both helix and
%   domain/selection drawing functions.
%
% (C) Rhiju Das, Stanford University, 2017

if isfield( obj, 'rectangle' ) & isvalid( obj.rectangle ) return; end;

h = rectangle( 'Position',[0,0,1,1],'edgecolor',[0.5 0.5 1],'clipping','off');
setappdata(h,tag_type,tag); 
draggable(h,'n',[-inf inf -inf inf],@move_snapgrid,'endfcn',redraw_fcn );
obj.rectangle = h;
setappdata(gca, tag, obj );
