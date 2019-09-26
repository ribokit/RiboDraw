function setup_eterna_theme();
%
% for fun, visualize how ribodraw might look like if it
%  is displayed in Eterna.
% Originally followed eterna_style_guide_v3.pdf, but later
%  later did over-ride based on manual picking of colors
%  with Mac OS digital color meter in low-graphics mode.
% 
% (C) R. Das, Stanford University, 2019

set_bg_color( [16,33,59]/255 );
set_line_color( 'white' );
set_symbol_color( 'white' );
fprintf( '\n Type set_default_theme() to restore the usual colors.\n' )