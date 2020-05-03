secstruct = '((..))';
stem_assignment = ribodraw_figure_out_stem_assignment( secstruct );
assert( all( stem_assignment == [1,1,0,0,1,1] ) );

secstruct = '(([[))]]';
stem_assignment = ribodraw_figure_out_stem_assignment( secstruct );
assert( all( stem_assignment == [1,1,2,2,1,1,2,2] ) );


secstruct = '(.)((.))';
bps = ribodraw_convert_structure_to_bps( secstruct );
assert( all( all( bps == [1,3;5,7;4,8] ) ) );

stems = ribodraw_parse_stems_from_bps( bps );
assert( length(stems) == 2 );
assert( all(stems{1} == [1,3]) );
assert( all(all(stems{2} == [4,8;5,7])) );

