function merge_drawing( merge_figure_number )
% merge_drawing( merge_figure_number )
% merge_drawing()
%
% reverses 'slice_drawing' 
%

if ~exist( 'merge_figure_number','var' )
    if ~isappdata( gca,'parent_figure_number' )
        fprintf( 'Cannot find parent_figure_number in gca -- please supply figure number to merge into.' );     
        return;
    end
    merge_figure_number = getappdata( gca, 'parent_figure_number' );
end

subdrawing = get_drawing();
figure( merge_figure_number );
import_drawing( subdrawing );
