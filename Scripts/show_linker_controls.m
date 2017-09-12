function show_linker_controls( setting )
if ~exist( 'setting', 'var' ) setting = 1; end;
plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_linker_controls = setting;
setappdata( gca, 'plot_settings', plot_settings );
set_control_handle_visibility( setting );

function set_control_handle_visibility( setting )
if setting; visible = 'on'; else; visible = 'off'; end;
% hide all blue stuff that was used for interactive movement.
vals = getappdata( gca );
objnames = fields( vals );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Linker_' ) );
        linker = getappdata( gca, objnames{n} );
        if isfield( linker, 'vtx' ) 
            for i = 1:length( linker.vtx ) set( linker.vtx{i},'visible', visible);  end;
        end;
    end
end
