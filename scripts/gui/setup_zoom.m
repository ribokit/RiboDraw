function setup_zoom()
% setup_zoom()
%
% Just call this once when setting up drawing.
%  Every time user zooms in or out, fontsize and arrow
%  widths will scale automatically.
%
% (C) R. Das, Stanford University, 2017

h = zoom;
set(h,'ActionPostCallback',@zoomCallBack);
set(h,'Enable','on');
zoom off;

% everytime you zoom in, this function is executed
function zoomCallBack(~, evd)

%update_artboards();
axis equal
reset_fontsize();
