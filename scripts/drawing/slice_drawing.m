function slice_drawing( slice_res )
% slice_drawing( slice_res )
% slice_drawing( slice_res_tags )
% slice_drawing( slice_domain )
% slice_drawing( {slice_domain1,slice_domain2...} )
%
% slices out a set of desired residues and any 
%  selections, linkers, and helices that are internal
%  to that set; produces a new window.
%
% INPUT
%  slice_res = string with residues, cell of res_tags, name of a domain.
%
% See also: MERGE_DRAWING
%
% (C) R. Das, Stanford University, 2017
parent_figure_number = get(gcf,'number');
subdrawing = get_drawing( slice_res );
if ~isfield( subdrawing, 'plot_settings' );  return; end;

figure()
load_drawing( subdrawing, 0, 1 );
setappdata( gca, 'parent_figure_number', parent_figure_number );

update_graphics_size() % fix font and line sizes.
