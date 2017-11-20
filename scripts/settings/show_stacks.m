function show_stacks( setting )
if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_stacks = setting;
setappdata( gca, 'plot_settings', plot_settings );

if setting; visible = 'on'; else; visible = 'off'; end;
linker_tags = get_tags( 'Linker_', 'stack' );
for i = 1:length( linker_tags )
    tag = linker_tags{i};
    linker = getappdata( gca, tag );
    set_linker_visibility( linker, visible );
end