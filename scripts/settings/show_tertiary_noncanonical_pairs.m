function show_tertiary_noncanonical_pairs( setting );
% show_tertiary_noncanonical_pairs( setting );
%
% show or hide (if setting is 1 or 0) noncanonical pairs  whose linker objects have been
%  grouped into tertiary_contacts (and have a tertiary_contact field)
%
% (C) R. Das, Stanford University, 2017-2018
if ~exist( 'setting', 'var' ); setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_tertiary_noncanonical_pairs = setting;
setappdata( gca, 'plot_settings', plot_settings );

linker_tags = [get_tags( 'Linker', 'noncanonical_pair'); get_tags( 'Linker', 'stem_pair')];

for i = 1:length( linker_tags )
    draw_linker( getappdata( gca, linker_tags{i} ) );
end
