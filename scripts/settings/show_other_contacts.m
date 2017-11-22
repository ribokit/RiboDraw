function show_other_contacts( setting )
% show_other_contacts( setting );
%
% Show or hide gray dashed lines associated with 'other contacts' (i.e
%   residue pairs that are not base paired or base stacked but form
%   a hydrogen bond involving the 2'-OH or phosphate), based on whether setting is 1 or 0.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_other_contacts = setting;
setappdata( gca, 'plot_settings', plot_settings );

if setting; visible = 'on'; else; visible = 'off'; end;
linker_tags = get_tags( 'Linker_', 'other_contact' );
for i = 1:length( linker_tags )
    tag = linker_tags{i};
    linker = getappdata( gca, tag );
    set_linker_visibility( linker, visible );
end
