function set_eterna_theme();
%
% for fun, visualize how ribodraw might look like if it
%  is displayed in Eterna.
% Originally followed eterna_style_guide_v3.pdf, but later
%  later did over-ride based on manual picking of colors
%  with Mac OS digital color meter in low-graphics mode.
% 
% (C) R. Das, Stanford University, 2019

set_bg_color( [16,33,59]/255 );
color_drawing( 'black' );
set_line_color( 'white' );
set_symbol_color( 'white' );

plot_settings = get_plot_settings();
plot_settings.bp_spacing = plot_settings.spacing;
plot_settings.eterna_theme = 1;
plot_settings.font_size = 12;
plot_settings.show_arrows = 0;
plot_settings.show_stem_pairs = 0;
setappdata( gca, 'plot_settings', plot_settings );
color_fill_circles_eterna;

draw_helices(); % force redraw of everything, including base rope.

fprintf( '\n Type set_default_theme() to restore the usual colors.\n' )
set_artboards