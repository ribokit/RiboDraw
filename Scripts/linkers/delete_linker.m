function linker = delete_linker( linker, remove_linker );
if ischar( linker ) linker = getappdata( gca, linker ); end;
if ~exist( 'remove_linker', 'var' ) remove_linker = 1; end;

linker = rmgraphics( linker, {'line_handle','symbol','symbol1','symbol2','side_line1','side_line2','node1','node2'} );
if isfield( linker, 'vtx' )
    for i = 1:length( linker.vtx ), delete( linker.vtx{i} ); end;
    linker = rmfield( linker, 'vtx' );
end;

if remove_linker
    rmappdata( gca, linker.linker_tag )
end

function linker = rmgraphics( linker, tags )
for i = 1:length( tags )
   tag = tags{i};
   if isfield( linker,tag ) 
       h = getfield(linker,tag);
       if isvalid( h ) delete(h); end;
       linker = rmfield( linker, tag );
   end;
end
