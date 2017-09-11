% eventually need to move these loops into separate functions.
stems = read_stems( '4ybb_DIII_stems.txt' );
[sequence,resnum,chains,non_standard_residues] = get_sequence( '4ybb_DIII.fasta' );
base_pairs = read_base_pairs( '4ybb_DIII_base_pairs.txt' ); % includes noncanonical pairs.

clf; set(gca,'Position',[0 0 1 1]);
hold on
t = zeros( 1, length(sequence ) );
axis( [0 200 0 200] );

plot_settings.fontsize   =10;
plot_settings.spacing    = 3;
plot_settings.bp_spacing = 6;
setappdata( gca, 'plot_settings', plot_settings );

stems = set_default_stem_positions( stems );
stems = setup_residues(  stems, sequence, resnum, chains );
setup_stem_partner( stems );
draw_dummy_linkers(resnum,chains);
setup_base_pair_linkers( base_pairs, canonical_pair_map )
draw_dummy_ticks();
initialize_linker_objects();
initalize_ticks();

draw_helices( stems );
