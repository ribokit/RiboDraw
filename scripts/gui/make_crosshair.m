function make_crosshair( pos );
% make_crosshair( pos );
%
% Create a temporary crosshair 
%   when dragging residues or boxes or linker vertices.
%
% Input
%
%  pos = position of element getting dragged.
%
% (C) R. Das, Stanford University, 2017

if ~isappdata( gca, 'vertical_crosshair' )
    setappdata( gca, 'vertical_crosshair', plot( [0 0],[0 0],'-', 'color', [0.5 0.5 1], 'linew',0.5,'clipping','off' ) );
end
if ~isappdata( gca, 'horizontal_crosshair' )
    setappdata( gca, 'horizontal_crosshair', plot([0 0],[0 0],'-', 'color', [0.5 0.5 1], 'linew',0.5,'clipping','off' ) );
end
xlim = get(gca,'xlim');
ylim = get(gca,'ylim');
set( getappdata( gca, 'vertical_crosshair')  , 'XData', pos(1)*[1 1], 'YData', ylim ); 
set( getappdata( gca, 'horizontal_crosshair'), 'XData', xlim,         'YData', pos(2)*[1 1] ); 
