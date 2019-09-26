function update_graphics_size( fontsize );
% reset_fontsize( fontsize );
%
%  Automatically set fonts and linker widths based on 
%    current x-axis limits and a heuristic for 
%    how the font should scale with those limits.
%
% (C) R. Das, Stanford University, 2017-2018


if ~exist( 'fontsize', 'var' ) 

    scalefactor = get_fontsize_over_axisunits();
    
    plot_settings = getappdata( gca, 'plot_settings' );
    if isempty( plot_settings ) return; end;

    fontsize = plot_settings.spacing * scalefactor(1);
    if isfield( plot_settings, 'eterna_theme' ) && plot_settings.eterna_theme; fontsize = fontsize*0.55; end;
    fontsize = max(fontsize,6);
end;

% change font size accordingly
set_fontsize( fontsize );
set_linker_width( fontsize );
