function show_selection_controls( setting, domains_only )
if ~exist( 'setting', 'var' ) setting = 1; end;
if ~exist( 'domains_only', 'var' ) domains_only = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_selection_controls = setting;
setappdata( gca, 'plot_settings', plot_settings );

if ( setting == 1 )
    % this is a hack -- Domains (non-coaxial selections) do not require
    %  object name of Domain!
    domains_only_tag = '';
    if domains_only; domains_only_tag = 'Domain'; end;
    draw_selections( get_tags( 'Selection_', domains_only_tag ) );
end

set_control_handle_visibility( setting );

function set_control_handle_visibility( setting )
if setting; visible = 'on'; else; visible = 'off'; end;
% hide all blue stuff that was used for interactive movement.
vals = getappdata( gca );
objnames = fields( vals );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Selection_' ) );
        selection = getappdata( gca, objnames{n} );
        if isfield( selection, 'rectangle' ); set( selection.rectangle,'visible', visible); end;
        if isfield( selection, 'auto_text' ); set( selection.auto_text,'visible', visible); end;
    end
end
