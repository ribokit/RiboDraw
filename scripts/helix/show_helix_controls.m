function show_helix_controls( setting );
% show_helix_controls( setting );
%
% Turn off/on (based on setting 0/1) the bounding
%  boxes that allow users to translate, reflect, and rotate
%  helices.
% 
% (C) R. Das, Stanford University

if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_helix_controls = setting;
setappdata( gca, 'plot_settings', plot_settings );

set_control_handle_visibility( setting );


function set_control_handle_visibility( setting )
if setting; visible = 'on'; else; visible = 'off'; end;

% hide all blue stuff that was used for interactive movement.
vals = getappdata( gca );
objnames = fields( vals );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Residue_' ) );
        residue = getappdata( gca, objnames{n} );
         if isfield( residue, 'residue_rectangle' ) set( residue.residue_rectangle, 'visible', visible); end;
    elseif ~isempty( strfind( objnames{n}, 'Helix_' ) );
        helix = getappdata( gca, objnames{n} );
        set_helix_visibility( helix, visible );
    end
end
plot_settings = getappdata( gca, 'plot_settings' );

