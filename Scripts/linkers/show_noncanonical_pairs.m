function show_noncanonical_pairs( setting )
if ~exist( 'setting', 'var' ) setting = 1; end;
if setting; visible = 'on'; else; visible = 'off'; end;
noncanonical_tags = get_tags( 'Linker_', 'noncanonical_pair' );
for i = 1:length( noncanonical_tags )
    tag = noncanonical_tags{i};
    linker = getappdata( gca, tag );
    if isfield( linker,'line_handle' ) set( linker.line_handle, 'visible', visible ); end;
    if isfield( linker,'symbol' ) set( linker.symbol, 'visible', visible ); end;
    if isfield( linker,'symbol1' ) set( linker.symbol1, 'visible', visible ); end;
    if isfield( linker,'symbol2' ) set( linker.symbol2, 'visible', visible ); end;
    if isfield( linker, 'vtx' ) 
        for i = 1:length( linker.vtx ) set( linker.vtx{i},'visible', visible);  end;
    end;
 end
