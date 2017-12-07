function setup_pan()
% setup_pan()
%
% Just call this once when setting up drawing.
%  Every time user pans, artboards are reset
%
% (C) R. Das, Stanford University, 2017

h = pan;
set(h,'ActionPostCallback',@panCallBack);
set(h,'Enable','on');
pan off;

% everytime you pan in, this function is executed
function panCallBack(~, evd)
%update_artboards();
