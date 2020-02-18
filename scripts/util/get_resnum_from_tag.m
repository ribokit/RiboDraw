function [resnum,chains,segid,ok] = get_resnum_from_tag( tag )
% [resnum,chains,segid,ok] = get_resnum_from_tag( tag )
%
% Convert "A:1-4"    to 'AAAA' and [1,2,3,4] 
%               or
%         "B:QA:2-3" to 'BB' and [2,3] and {'QA','QA'}
%
% INPUT:
%   tag = string like "B:QA:2-3" or "A:1-4"  (missing segid)
%
% OUTPUT
%  resnum = number           (integer)
%  chain  = chain characters (string with length matching resnum)
%  segid  = segment IDs      (cell of strings with length matching resnum, may all be blank)
%  ok     = 1 if tag follows acceptable forms, 0 otherwise
%
% (C) R. Das, Stanford University

% there might be multiple tags like "A:1-4 B:1-4"
residue_tags = strsplit( tag );
if length( residue_tags ) > 1
    resnum = [];
    chains = '';
    segid  = {};
    ok = true;
    for i = 1:length( residue_tags )
        [tag_resnum,tag_chains,tag_segid,ok] = get_resnum_from_tag( residue_tags{i} );
        if ok
            resnum = [ resnum, tag_resnum ];
            chains = [ chains, tag_chains ];
            segid  = [ segid, tag_segid ];
        end
    end
    return;
end

% following is for single tag like "A:1-4"
resnum = [];
chains = '';
segid  = {''};
ok = false;
if isempty( strfind( tag , ':' ) ) return; end;
elems = strsplit( tag, ':' );
chain = elems{1}; chains = chain;
if length( elems ) == 3
    segid = {elems{2}};
    elems = elems([1,3]);
end
dashes = strfind( elems{2}, '-' );
if length( dashes ) == 0 | ( length(dashes) == 1 && dashes(1) == 1);
    resnum = str2num( elems{2} );
    ok = true;
    return;
end
dash = dashes(1);
if dash == 1; assert( length( dashes ) > 1 ); dash = dashes(2); end;
start_res = str2num( elems{2}(1:dash-1) );
if isempty ( start_res ); return; end;
stop_res = str2num( elems{2}((dash+1):end) );
if isempty ( stop_res ); return; end;
if( stop_res <= start_res ); return; end;
resnum = start_res:stop_res;
chains = repmat( chain, [1 length(resnum)] );
segid  = repmat( segid, [1 length(resnum)] );
ok = true;