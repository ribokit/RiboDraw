function setup_zoom()
h = zoom;
set(h,'ActionPostCallback',@zoomCallBack);
set(h,'Enable','on');
zoom off;

% everytime you zoom in, this function is executed
function zoomCallBack(~, evd)
% Since i expect to zoom in ax(4)-ax(3) gets smaller, so fontsize
% gets bigger.
ax = axis(evd.Axes); % get axis size
reset_fontsize();
