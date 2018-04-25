function show_interdomain_noncanonical_pairs( setting );
% show_interdomain_noncanonical_pairs( setting );
%
% show or hide (if setting is 1 or 0) noncanonical pairs whose linker objects have the
%  .interdomain field.
%
% NOTE: This function or others may need to be updated; code like
%  GROUP_INTERDOMAIN_LINKERS no longer seems to be setting the interdomain field.
%
% (C) R. Das, Stanford University
if ~exist( 'setting', 'var' ); setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_interdomain_noncanonical_pairs = setting;
setappdata( gca, 'plot_settings', plot_settings );

linker_tags = [get_tags( 'Linker', 'noncanonical_pair'); get_tags( 'Linker', 'stem_pair')];

for i = 1:length( linker_tags )
    draw_linker( getappdata( gca, linker_tags{i} ) );
end
