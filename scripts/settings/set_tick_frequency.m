function set_tick_frequency( tick_frequency )
% set_tick_frequency( tick_frequency )
%
% Set frequency at which ticks are displayed
% 
% (C) R. Das, Stanford University, 2017

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.tick_frequency = tick_frequency;
setappdata( gca, 'plot_settings', plot_settings );
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% apply new setting
redraw_helices();
