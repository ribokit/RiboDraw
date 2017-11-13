function slice_drawing( slice_res )
% slice_drawing( slice_res )
% slice_drawing( slice_res_tags )
% slice_drawing( slice_domain )
% slice_drawing( {slice_domain1,slice_domain2...} )

slice_res
subdrawing = get_drawing( slice_res );
if ~isfield( subdrawing, 'plot_settings' );  return; end;
figure()
subdrawing
load_drawing( subdrawing, 0, 1 );

