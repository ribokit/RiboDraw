function set_tertiary_contact_domain_coloring( setting )
if ~exist( 'setting', 'var' ) setting = 1; end;
plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.tertiary_contact_domain_coloring = setting;
setappdata( gca, 'plot_settings', plot_settings );
tags = [ get_tags( 'Linker', 'tertcontact_interdomain' ), get_tags( 'Linker','tertcontact_intradomain' ) ];
for i = 1:length( tags )
    draw_linker( getappdata( gca, tags{i} ) );
end
