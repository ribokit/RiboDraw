[resnum,chain,segid] = get_resnum_from_tag( 'A:QX:1-4 B:1-3' );
assert( all(resnum == [ 1     2     3     4     1     2     3]) );
assert( strcmp( chain, 'AAAABBB' ) );
assert( all(strcmp(segid, {'QX','QX','QX','QX','','',''})));

[resnum,chain,segid] = get_resnum_from_tag( 'A:-3-1' );
assert( all(resnum == [-3:1]) );
assert( strcmp( chain, 'AAAAA' ) );
assert( all(strcmp(segid, {'','','','',''})));
