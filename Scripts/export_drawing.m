function export_drawing( filename )

cols = strsplit( filename, '.' );
switch cols{end}
    case {'eps','ps','ai'}
        opt = '-depsc2';
    case 'pdf'
        opt = '-dpdf';
    case 'jpg','jpeg'
        opt = '-djpg';
    case 'png'
        opt = '-dpng';
    otherwise 
        fprintf( 'Unrecognized extension' )
        help
        return;
end

set_control_handle_visibility( 'off' );
print( filename, opt );
fprintf( 'Created: %s\n', filename ); 
set_control_handle_visibility( 'on' );


function set_control_handle_visibility( visible )
% hide all blue stuff that was used for interactive movement.
vals = getappdata( gca );
objnames = fields( vals );
hide_handles = {};
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Residue_' ) );
        residue = getappdata( gca, objnames{n} );
         if isfield( residue, 'residue_rectangle' ) set( residue.residue_rectangle, 'visible', visible); end;
    elseif ~isempty( strfind( objnames{n}, 'Helix_' ) );
        helix = getappdata( gca, objnames{n} );
        if isfield( helix, 'click_center' )   set( helix.click_center,'visible', visible); end;
        if isfield( helix, 'reflect_line' )   set( helix.reflect_line, 'visible', visible); end;
        if isfield( helix, 'helix_rectangle' ) set( helix.helix_rectangle, 'visible', visible); end;
    end
end
for i = 1:length( hide_handles ); 
    get( hide_handles{i} )
    set( hide_handles{i}, 'visible','off' );
end;


