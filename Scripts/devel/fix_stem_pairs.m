function fix_stem_pairs()
tags = get_tags( 'Linker_','stem_pair');
for i = 1: length( tags )
    tag = tags{i};
    linker = getappdata( gca, tag );
    if strcmp( linker.type, 'noncanonical_pair' )
        fprintf( 'need to cleanup %s\n', linker.linker_tag );
        if isfield( linker, 'vtx' ); linker = rmfield( linker, 'vtx' ); end;
        if isfield( linker, 'line_handle' ); linker = rmfield( linker, 'line_handle' ); end;
        if isfield( linker, 'symbol' ); linker = rmfield( linker, 'symbol' ); end;
        if isfield( linker, 'symbol1' ); linker = rmfield( linker, 'symbol1' ); end;
        if isfield( linker, 'symbol2' ); linker = rmfield( linker, 'symbol2' ); end;
        setappdata( gca, linker.linker_tag, linker );
    end
end
