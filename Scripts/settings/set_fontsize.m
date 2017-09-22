function set_fontsize( fontsize )
plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.fontsize = fontsize;
setappdata( gca, 'plot_settings', plot_settings );

        
