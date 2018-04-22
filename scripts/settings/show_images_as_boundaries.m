function show_images_as_boundaries()
% show_images_as_boundaries();
%
% Show image_boundaries ('silhouettes') as images
%
% (C) R. Das, Stanford University, 2018

if ~exist( 'setting', 'var' ); setting = 1; end;
plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.image_representation = 'image_boundary';
setappdata( gca, 'plot_settings', plot_settings );
hide_images;
show_images;