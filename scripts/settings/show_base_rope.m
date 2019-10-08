function show_base_rope( setting )
% show_base_rope( setting )
%
% Show or hide 'base rope' that connects all residue with smooth curve.
%
% (C) R. Das, Stanford University, 2019

if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_base_rope = setting;
setappdata( gca, 'plot_settings', plot_settings );

draw_base_rope();
if ( setting ) move_stuff_to_back; end;