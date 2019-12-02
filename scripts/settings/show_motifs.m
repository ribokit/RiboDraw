function show_motifs( setting );
% show_helix_controls( setting );
%
% Turn off/on (based on setting 0/1) the motifs
%  that are drawn as rounded rectangles
% 
% (C) R. Das, Stanford University, 2019

if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_motifs = setting;
setappdata( gca, 'plot_settings', plot_settings );

draw_motifs();
if setting; move_stuff_to_back; end;
