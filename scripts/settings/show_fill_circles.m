function show_fill_circles( setting );
% show_helix_controls( setting );
%
% Turn off/on (based on setting 0/1) the fill circles
%  that are drawn as 'fill_circles'
%  letter.
% 
% (C) R. Das, Stanford University, 2019

if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_fill_circles = setting;
setappdata( gca, 'plot_settings', plot_settings );

draw_residues();
if setting; move_stuff_to_back; end;
