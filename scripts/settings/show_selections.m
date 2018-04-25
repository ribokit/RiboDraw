function show_selections( setting )
% show_selections( setting );
%
% Show or hide lines with Leontis-Westhof symbol for noncanonical pairs, based on 
%    whether setting is 1 or 0.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ); setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_selections = setting;
setappdata( gca, 'plot_settings', plot_settings );

linker_tags = get_tags( 'Linker', 'selection');

for i = 1:length( linker_tags )
    draw_linker( getappdata( gca, linker_tags{i} ) );
end
