function show_split_arrow_lines( setting )
% show_split_arrows( linker, setting, domain_names )
%
% Show or hide thin gray lines that trace the interdomain_linker between
%  two residues that define a TertiaryContact. Allows user to reduce
%  clutter in the drawing.
%
% See also: SHOW_SPLIT_ARROWS, GROUP_INTERDOMAIN_LINKERS
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_split_arrow_lines = setting;
setappdata( gca, 'plot_settings', plot_settings );
draw_linker( get_tags( 'Linker','interdomain' ) );
