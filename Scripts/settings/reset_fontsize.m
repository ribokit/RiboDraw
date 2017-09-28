function reset_fontsize( redraw );
if ~exist( 'redraw','var') redraw = 1; end;
xlim = get(gca,'xlim' );
fontsize = 2000/(xlim(2)-xlim(1));
% change font size accordingly
set_fontsize( fontsize );
