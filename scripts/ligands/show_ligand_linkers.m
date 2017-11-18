function show_ligand_linkers( setting );
if ~exist( 'setting', 'var' ); setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_ligand_linkers = setting;
setappdata( gca, 'plot_settings', plot_settings );

linker_tags = get_tags( 'Linker', 'ligand');

for i = 1:length( linker_tags )
    draw_linker( getappdata( gca, linker_tags{i} ) );
end
