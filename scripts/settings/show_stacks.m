function show_stacks( setting )
% show_stacks( setting );
%
% Show or hide gray dotted lines associated with stacked residues that
%   are far apart in the drawing, based on whether setting is 1 or 0.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_stacks = setting;
setappdata( gca, 'plot_settings', plot_settings );

linker_tags = get_tags( 'Linker_', 'stack' );
for i = 1:length( linker_tags )
    draw_linker( linker_tags{i} );
end