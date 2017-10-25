function delete_linker( linker );

if isfield( linker,'line_handle' ) delete( linker.line_handle ); end;
if isfield( linker,'symbol' ) delete( linker.symbol ); end;
if isfield( linker,'symbol1' ) delete( linker.symbol1 ); end;
if isfield( linker,'symbol2' ) delete( linker.symbol2 ); end;
if isfield( linker,'side_line1' ) delete( linker.side_line1 ); end;
if isfield( linker,'side_line2' ) delete( linker.side_line2 ); end;
if isfield( linker,'node1' ) delete( linker.node1 ); end;
if isfield( linker,'node2' ) delete( linker.node2 ); end;
if isfield( linker, 'vtx' )
    for i = 1:length( linker.vtx ), delete( linker.vtx{i} ); end;
end;
rmappdata( gca, linker.linker_tag )
