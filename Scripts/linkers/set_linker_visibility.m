function linker = set_linker_visibility( linker, visible );

if isfield( linker,'line_handle' ) set( linker.line_handle, 'visible', visible ); end;
if isfield( linker,'symbol' ) set( linker.symbol, 'visible', visible ); end;
if isfield( linker,'symbol1' ) set( linker.symbol1, 'visible', visible ); end;
if isfield( linker,'symbol2' ) set( linker.symbol2, 'visible', visible ); end;
if isfield( linker, 'vtx' )
    for i = 1:length( linker.vtx ) set( linker.vtx{i},'visible', visible);  end;
end;
