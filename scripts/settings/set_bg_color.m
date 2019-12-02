function set_bg_color( color );
% set_bg_color( color )
%
% set background color. 
%
% INPUT
%  color = [optional] text color like 'white' or RGB value like [1,1,1]
%           if not specified, check plot_settings.bg_color. if that is not
%           specified use [1,1,1] (white).
%
% (C) R. Das, Stanford University, 2019

if exist( 'color', 'var' )
    plot_settings = getappdata( gca, 'plot_settings' );
    plot_settings.bg_color = pymol_RGB( color );
    setappdata( gca, 'plot_settings', plot_settings );
end

plot_settings = getappdata( gca, 'plot_settings' );
if ~isfield( plot_settings, 'bg_color' ); set_bg_color( [1,1,1] ); return; end;
set(gcf,'color',plot_settings.bg_color)

