function slice_drawing( slice_res )
% slice_drawing( slice_res )
% slice_drawing( slice_res_tags )
% slice_drawing( slice_domain )
% slice_drawing( {slice_domain1,slice_domain2...} )

parent_figure_number = get(gcf,'number');
subdrawing = get_drawing( slice_res );
if ~isfield( subdrawing, 'plot_settings' );  return; end;

figure()
load_drawing( subdrawing, 0, 1 );
setappdata( gca, 'parent_figure_number', parent_figure_number );

