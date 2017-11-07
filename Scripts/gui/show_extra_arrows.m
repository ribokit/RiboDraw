function show_extra_arrows( setting )
if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_extra_arrows = setting;
setappdata( gca, 'plot_settings', plot_settings );

draw_linker( get_tags('Linker','arrow') );
