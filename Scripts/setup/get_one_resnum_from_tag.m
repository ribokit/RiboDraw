function [resnum,chains,segid,ok] = get_one_resnum_from_tag( tag )
% Convert "A:CQ:1" to 'A','CQ',1
[resnum,chains,segid,ok] = get_resnum_from_tag( tag );
if ok
    assert( length( resnum ) == 1 );
    assert( length( chains ) == 1 );
    assert( length( segid ) == 1 );
    segid = segid{1};
end
