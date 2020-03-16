% setupTests
fprintf( '\nTo run these unit tests, go to RiboDraw/unittests and type\n runtests;\n\n');
tag =  'testdata/1ehz.pdb';
initialize_drawing( tag );
nc_pairs = get_tags( 'Linker','noncanonical_pair' );

%% initialize_drawing
assert( isappdata( gca, 'Residue_A45' ) );
assert( isappdata( gca, 'Linker_A17_A18_arrow' ) );
assert( length(get(gca,'Children')) > 100 );
r = getappdata( gca, 'Residue_A45' );
assert( strcmp( r.res_tag, 'Residue_A45' ) );
assert( strcmp( r.handle.Type,'text') );

%% hide noncanonical pairs
assert( length( nc_pairs ) > 0 );
nc_pair = getappdata(gca,nc_pairs{1});
assert( isfield( nc_pair, 'line_handle') );
assert( strcmp(get(nc_pair.line_handle,'visible'),'on') );

hide_noncanonical_pairs;
nc_pairs = get_tags( 'Linker','noncanonical_pair' );
nc_pair = getappdata(gca,nc_pairs{1});
assert( ~isfield( nc_pair, 'line_handle') );

%% show noncanonical pairs
show_noncanonical_pairs;
nc_pair = getappdata(gca,nc_pairs{1});
assert( isfield( nc_pair, 'line_handle') );
assert( strcmp(get(nc_pair.line_handle,'visible'),'on') );


%% show motifs/hide motifs
assert( isappdata( gca, 'Motif_U_TURN_A33' ) )
motif = gd( 'Motif_U_TURN_A33' );
assert( ~isfield( motif, 'highlight_box_handles' ) );

show_motifs
motif = gd( 'Motif_U_TURN_A33' );
assert( isfield(  motif, 'highlight_box_handles' ) )
assert( length( motif.highlight_box_handles ) == 1 );

motif = gd( 'Motif_INTERCALATED_T_LOOP_A53' );
assert( isfield(  motif, 'highlight_box_handles' ) )
assert( length( motif.highlight_box_handles ) == 2 );

hide_motifs
motif = gd( 'Motif_U_TURN_A33' );
assert( ~isfield(  motif, 'highlight_box_handles' ) )
motif = gd( 'Motif_INTERCALATED_T_LOOP_A53' );
assert( ~isfield(  motif, 'highlight_box_handles' ) )

%% should be able to find parse_stems_from_bps command
assert( length( parse_stems_from_bps([ 1 10 ; 2 9 ; 5 12 ; 6 11 ; 3 8 ; 4 7 ]) ) == 3 )
