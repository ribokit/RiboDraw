function [resnum,chain,segid,ok] = get_one_resnum_from_tag( tag )
% [resnum,chain,segid,ok] = get_one_resnum_from_tag( tag )
%
% Convert "A:CQ:1" to 'A','CQ',1
%
% INPUT:
%   tag = string like "A:CQ:1" or "B:2" (missing segid)
%
% OUTPUT
%  resnum = number          (integer)
%  chain  = chain character (string with length 1)
%  segid  = segment ID      (string, may be blank)
%  ok     = 1 if tag follows acceptable forms, 0 otherwise
%
% (C) R. Das, Stanford University


[resnum,chain,segid,ok] = get_resnum_from_tag( tag );

if ok
    assert( length( resnum ) == 1 );
    assert( length( chain ) == 1 );
    assert( length( segid ) == 1 );
    segid = segid{1};
end
