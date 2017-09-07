function [resnum,chains,ok] = get_resnum_from_tag( tag )
% Convert "A:1-4" to 'AAAA' and [1,2,3,4]
resnum = [];
chains = '';
ok = false;
if isempty( strfind( tag , ':' ) ) return; end;
elems = strsplit( tag, ':' );
chains = elems{1};
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