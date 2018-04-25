function show_plot_settings()

plot_settings = getappdata( gca, 'plot_settings' );
disp( plot_settings );
fprintf( 'To adjust settings, the useful functions are in <a href="matlab: what settings">RiboDraw settings</a>\n' );
