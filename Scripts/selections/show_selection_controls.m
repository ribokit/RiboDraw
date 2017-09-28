function show_selection_controls( setting, selection_tag )
if ~exist( 'setting', 'var' ) setting = 1; end;
if ~exist( 'selection_tag', 'var' ) selection_tag = ''; end;

plot_settings = getappdata( gca, 'plot_settings' );
if strcmp( selection_tag, 'Domain' )
    plot_settings.show_domain_controls = setting;
    setappdata( gca, 'plot_settings', plot_settings );
elseif strcmp( selection_tag, 'coaxial_stack' )
    plot_settings.show_coax_controls = setting;
    setappdata( gca, 'plot_settings', plot_settings );
end

tags = get_tags( 'Selection_', selection_tag );
if ( setting == 1 )
    draw_selections( tags );
end

% hide all blue stuff that was used for interactive movement.
if setting; visible = 'on'; else; visible = 'off'; end;
for n = 1:length(tags)
    selection = getappdata( gca, tags{n} );
    if isfield( selection, 'rectangle' ); set( selection.rectangle,'visible', visible); end;
    if isfield( selection, 'auto_text' ); set( selection.auto_text,'visible', visible); end;
end
