function reset_fontsize();
xlim = get(gca,'xlim' );
fontsize = 2000/(xlim(2)-xlim(1));
% change font size accordingly
set_fontsize( fontsize );
redraw_helices();