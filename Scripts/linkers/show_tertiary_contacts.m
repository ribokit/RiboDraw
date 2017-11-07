function show_tertiary_contacts( setting );
if ~exist( 'setting', 'var' ); setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_tertiary_contacts = setting;
setappdata( gca, 'plot_settings', plot_settings );

linker_tags = [ get_tags( 'Linker', 'interdomain'), get_tags( 'Linker', 'intradomain')];

for i = 1:length( linker_tags )
    draw_linker( linker_tags{i} );
end
