function linker = delete_linker( linker, remove_linker );
% linker = delete_linker( linker, remove_linker )
%
% Delete a linker and all associated graphics handles.
%
% Inputs
%  linker = linker object or tag for linker. Cell of several such objects 
%              or tags is also acceptable
%  remove_linker = 0/1 to actually delete linker from drawing (gca) rather
%                   than simply erase graphics handles. (default: 1, total destruction)
%
% Output
%  linker = the struct() after removal of graphics handles.
%
% (C) R. Das, Stanford University.

if ~exist( 'remove_linker', 'var' ) remove_linker = 1; end;
if iscell( linker )
    for i = 1:length( linker ); 
        linker{i} = delete_linker( linker{i}, remove_linker ); 
    end; 
    return; 
end;
if ischar( linker ) linker = getappdata( gca, linker ); end;

linker = rmgraphics( linker, {'line_handle','arrow','symbol','symbol1','symbol2','side_line1','side_line2','node1','node2','outarrow1','outarrow2','outarrow_label1','outarrow_label2'} );
if isfield( linker, 'vtx' )
    for i = 1:length( linker.vtx ); delete( linker.vtx{i} );  end;
    linker = rmfield( linker, 'vtx' );
end;

if remove_linker
    residue1 = getappdata( gca, linker.residue1 );
    residue1.linkers = setdiff( residue1.linkers, linker.linker_tag );
    setappdata( gca, linker.residue1, residue1 );
    
    residue2 = getappdata( gca, linker.residue2 );
    residue2.linkers = setdiff( residue2.linkers, linker.linker_tag );
    setappdata( gca, linker.residue2, residue2 );
    
    rmappdata( gca, linker.linker_tag );
end

