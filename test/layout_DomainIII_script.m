% eventually need to move these loops into separate functions.
stems = read_stems( '4ybb_DIII_stems.txt' );
[sequence,resnum,chains,non_standard_residues] = get_sequence( '4ybb_DomainIII.fasta' );
setappdata( gca, 'sequence', sequence );
setappdata( gca, 'resnum', resnum );
setappdata( gca, 'chains', chains );
setappdata( gca, 'non_standard_residues', non_standard_residues );
setappdata( gca, 'stems', stems );
base_pairs = read_base_pairs( '4ybb_DIII_base_pairs.txt' ); % includes noncanonical pairs.
setappdata( gca, 'base_pairs', base_pairs );

clf; set(gca,'Position',[0 0 1 1]);
hold on
t = zeros( 1, length(sequence ) );
axis( [0 200 0 200] );

plot_settings.fontsize   =10;
plot_settings.spacing    = 3;
plot_settings.bp_spacing = 6;
setappdata( gca, 'plot_settings', plot_settings );

stems = set_default_stem_positions( stems );
stems = setup_residues( stems, sequence, resnum, chains );
setup_stem_partner( stems );
initalize_ticks();
draw_dummy_linkers();
draw_dummy_base_pairs( base_pairs, canonical_pair_map )
draw_dummy_ticks();
draw_helices( stems );
