function obj = create_default_rectangle( obj, tag_type, tag, redraw_fcn )

if isfield( obj, 'rectangle' ) return; end;

h = rectangle( 'Position',[0,0,1,1],'edgecolor',[0.5 0.5 1],'clipping','off');
setappdata(h,tag_type,tag); 
draggable(h,'n',[-inf inf -inf inf],@move_snapgrid,'endfcn',redraw_fcn );
obj.rectangle = h;
setappdata(gca, tag, obj );
