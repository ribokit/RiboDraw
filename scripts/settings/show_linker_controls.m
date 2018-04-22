function show_linker_controls( setting )
% show_linker_controls( setting );
%
% Show or hide symbols that allow user to adjust linker paths,
%  depending on whether setting is 1 or 0.
%
% (C) R. Das, Stanford University

if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_linker_controls = setting;
setappdata( gca, 'plot_settings', plot_settings );

set_control_handle_visibility( setting );

function set_control_handle_visibility( setting )
if setting; visible = 'on'; else; visible = 'off'; end;
% hide all blue stuff that was used for interactive movement.
objnames = get_tags( 'Linker' );

% outright destroy or create the vertices -- trying to reduce number of
% graphics objects in window.
for n = 1:length( objnames )
    draw_linker( objnames{n} );
end


% OLD -- toggle graphics 'visible' field.
% for n = 1:length( objnames )
%     linker = getappdata( gca, objnames{n} );
%     if isfield( linker, 'vtx' ) & isfield( linker, 'line_handle' ) & isvalid( linker.line_handle )
%         vtx_visible = visible;
%         if strcmp( get( linker.line_handle, 'visible' ), 'off' ) vtx_visible = 'off'; end;
%         for i = 1:length( linker.vtx ) set( linker.vtx{i},'visible', vtx_visible);  end;
%     end;
% end
