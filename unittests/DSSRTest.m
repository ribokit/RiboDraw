
%%
dssr_pairs = read_dssr_base_pairs( 'testdata/1gid_RNAA.pdb.dssr.out' );
assert( length( dssr_pairs ) == 81 );
assert( ~isempty(dssr_pairs{1}.resnum1) );
assert( ~isempty(dssr_pairs{1}.chain1) );

%%
dssr_idstr_pairs = read_dssr_base_pairs( 'testdata/1gid_RNAA.pdb.dssr.idstrlong.out' );
assert( length( dssr_idstr_pairs ) == 81 );
assert( ~isempty(dssr_idstr_pairs{1}.resnum1) );
assert( ~isempty(dssr_idstr_pairs{1}.chain1) );

%%
dssr_idstr_pairs = read_dssr_base_pairs( 'testdata/4ybb_16S.pdb.dssr.idstrlong.out' );
assert( length( dssr_idstr_pairs ) == 757 );
assert( ~isempty(dssr_idstr_pairs{1}.resnum1) );
assert( ~isempty(dssr_idstr_pairs{1}.chain1) );

