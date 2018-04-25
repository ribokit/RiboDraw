% setupTests
fprintf( '\nTo run these unit tests, go to RiboDraw/unittests and type\n runtests;\n\n');
tag =  'testdata/1ehz.pdb';
nc_pairs = get_tags( 'Linker','noncanonical_pair' );

%% initialize_drawing
initialize_drawing( tag );
assert( isappdata( gca, 'Residue_A45' ) );
assert( isappdata( gca, 'Linker_A17_A18_arrow' ) );
assert( length(get(gca,'Children')) > 400 );
r = getappdata( gca, 'Residue_A45' );
assert( strcmp( r.res_tag, 'Residue_A45' ) );
assert( strcmp( r.handle.Type,'text') );

%% hide noncanonical pairs
assert( length( nc_pairs ) > 0 );
nc_pair = getappdata(gca,nc_pairs{1});
assert( isfield( nc_pair, 'line_handle') );
assert( strcmp(get(nc_pair.line_handle,'visible'),'on') );
hide_noncanonical_pairs;
assert( isfield( nc_pair, 'line_handle') );
assert( strcmp(get(nc_pair.line_handle,'visible'),'off') )

%% show noncanonical pairs
show_noncanonical_pairs;
nc_pair = getappdata(gca,nc_pairs{1});
assert( isfield( nc_pair, 'line_handle') );
assert( strcmp(get(nc_pair.line_handle,'visible'),'on') );