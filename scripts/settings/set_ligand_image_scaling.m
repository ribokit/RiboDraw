function set_ligand_image_scaling( setting );
% set_ligand_image_scaling( setting );
% 
% Set how much to scale input images for ligands for drawing
%  in RiboDraw. 
% Typically needs to be adjusted manually between 0.5 to 4 so that
%  ligands (like proteins) look roughly 'at scale' with RNA helices.
%
% (C) R. Das, Stanford University, 2017

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.ligand_image_scaling = setting;
setappdata( gca, 'plot_settings', plot_settings );

tags = get_tags( 'Residue' );
for i = 1:length( tags )
    obj = getappdata( gca, tags{i} );
    if isfield( obj, 'image_boundary' ) draw_image( obj ); end;
end
