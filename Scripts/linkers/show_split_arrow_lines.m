function show_split_arrow_lines( setting )
if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_split_arrow_lines = setting;
setappdata( gca, 'plot_settings', plot_settings );
draw_linker( get_tags( 'Linker','interdomain' ) );
