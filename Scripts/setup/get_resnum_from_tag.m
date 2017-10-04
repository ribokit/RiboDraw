function [resnum,chains,ok] = get_resnum_from_tag( tag )
% Convert "A:1-4" to 'AAAA' and [1,2,3,4]

% there might be multiple tags like "A:1-4 B:1-4"
residue_tags = strsplit( tag );
if length( residue_tags ) > 1
    resnum = [];
    chains = '';
    ok = true;
    for i = 1:length( residue_tags )
        [tag_resnum,tag_chains,ok] = get_resnum_from_tag( residue_tags{i} );
        if ok
            resnum = [ resnum, tag_resnum ];
            chains = [ chains, tag_chains ];
        else
            ok = false;
            return
        end
    end
    return;
end

% following is for single tag like "A:1-4"

resnum = [];
chains = '';
ok = false;
if isempty( strfind( tag , ':' ) ) return; end;
elems = strsplit( tag, ':' );
chain = elems{1}; chains = chain;
dashes = strfind( elems{2}, '-' );
if length( dashes ) == 0 | dashes(1) == 1;
    resnum = str2num( elems{2} );
    return;
end
dash = dashes(1);
if dash == 1; assert( length( dashes ) > 1 ); dash == dashes(2); end;
start_res = str2num( elems{2}(1:dash-1) );
if isempty ( start_res ); return; end;
stop_res = str2num( elems{2}((dash+1):end) );
if isempty ( stop_res ); return; end;
if( stop_res <= start_res ); return; end;
resnum = start_res:stop_res;
chains = repmat( chain, [1 length(resnum)] );
ok = true;