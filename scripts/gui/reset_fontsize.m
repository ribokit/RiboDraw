function reset_fontsize( fontsize );
% reset_fontsize( fontsize );
%
%  Automatically set fonts and linker widths based on 
%    current x-axis limits and a heuristic for 
%    how the font should scale with those limits.
%
% (C) R. Das, Stanford University, 2017


if ~exist( 'fontsize', 'var' ) 
    xlim = get(gca,'xlim' );
    fontsize = 2700/(xlim(2)-xlim(1)); 
end;
% change font size accordingly
set_fontsize( fontsize );
set_linker_width( fontsize );
