function reset_fontsize( fontsize );
xlim = get(gca,'xlim' );
if ~exist( 'fontsize', 'var' ) fontsize = 2000/(xlim(2)-xlim(1)); end;
% change font size accordingly
set_fontsize( fontsize );
set_linker_width( fontsize );
