function set_tertiary_contact_domain_coloring( setting )
% set_tertiary_contact_domain_coloring( setting )
%
% Show or hide colors of tertiary contacts (and grouped protein-RNA connections which
%   are defined as 'tertiary contacts') based on rgb colors of
%   interconnected domains, depending on whether setting is 1 or 0.
%
% Allows user to decide whether to give more information or declutter based on how many of
%   those linkers are there.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ) setting = 1; end;
plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.tertiary_contact_domain_coloring = setting;
setappdata( gca, 'plot_settings', plot_settings );
tags = [ get_tags( 'Linker', 'tertcontact_interdomain' ); get_tags( 'Linker','tertcontact_intradomain' ) ];
for i = 1:length( tags )
    draw_linker( getappdata( gca, tags{i} ) );
end
