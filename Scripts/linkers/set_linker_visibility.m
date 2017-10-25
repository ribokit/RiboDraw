function linker = set_linker_visibility( linker, visible );

if isfield( linker,'line_handle' ) set( linker.line_handle, 'visible', visible ); end;
if isfield( linker,'symbol' ) set( linker.symbol, 'visible', visible ); end;
if isfield( linker,'symbol1' ) set( linker.symbol1, 'visible', visible ); end;
if isfield( linker,'symbol2' ) set( linker.symbol2, 'visible', visible ); end;
if isfield( linker,'side_line1' ) set( linker.side_line1, 'visible', visible ); end;
if isfield( linker,'side_line2' ) set( linker.side_line2, 'visible', visible ); end;
if isfield( linker,'node1' ) set( linker.node1, 'visible', visible ); end;
if isfield( linker,'node2' ) set( linker.node2, 'visible', visible ); end;
if isfield( linker, 'vtx' )
    vtx_visible = visible;
    plot_settings = getappdata( gca, 'plot_settings' );
    if ( isfield( plot_settings, 'show_linker_controls' ) & ~plot_settings.show_linker_controls ) vtx_visible = 'off'; end;
    for i = 1:length( linker.vtx ), set( linker.vtx{i}, 'visible', vtx_visible ); end;
end;
