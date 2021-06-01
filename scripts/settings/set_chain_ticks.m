function set_chain_ticks( chain_ticks )
% set_chain_ticks( chain_ticks )
%
% Set whether chains are included in tick labels
% 
% (C) R. Das, Stanford University, 2017

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.chain_ticks = chain_ticks;
setappdata( gca, 'plot_settings', plot_settings );
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% apply new setting
redraw_helices();
