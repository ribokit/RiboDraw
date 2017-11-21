function merge_drawing( merge_figure_number )
% merge_drawing( merge_figure_number )
% merge_drawing()
%
% Reverses 'slice_drawing' -- by default puts the edited 
%   subdrawing back in its parent drawing.
%
% INPUT
%   merge_figure_number = [Optional] figure number to use as
%                           parent. In typical use case this does
%                           not have to be supplied -- the
%                           subdrawing will remember its parent
%                           if created by slice_res
%
%  See also: SLICE_DRAWING.           
%
% (C) R. Das, Stanford University, 2017

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
