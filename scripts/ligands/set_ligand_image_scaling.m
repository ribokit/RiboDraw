function set_ligand_image_scaling( setting );

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.ligand_image_scaling = setting;
setappdata( gca, 'plot_settings', plot_settings );

tags = get_tags( 'Residue' );
for i = 1:length( tags )
    obj = getappdata( gca, tags{i} );
    if isfield( obj, 'image_boundary' ) draw_image_boundary( obj ); end;
end
