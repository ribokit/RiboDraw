function initialize_drawing( tag )

[sequence,resnum,chains,non_standard_residues] = get_sequence( [tag,'.fasta']);
base_pairs = read_base_pairs( [tag,'.base_pairs.txt'] ); % includes noncanonical pairs.
base_stacks = read_base_stacks( [tag,'.stacks.txt'] ); % includes noncanonical pairs.
stems = read_stems( [tag,'.stems.txt'] );

clf; set(gca,'Position',[0 0 1 1]);
hold on
t = zeros( 1, length(sequence ) );
axis( [0 200 0 200] );

setappdata( gca, 'plot_settings', default_plot_settings );

stems = set_default_stem_positions( stems ); % helix_center setup  could happen *inside* draw_helix or draw_helices
stems = setup_residues(  stems, sequence, resnum, chains ); %  helix_tag setup could happen inside draw_helices
setup_stem_partner( stems ); % could happen inside draw_helices? need some kind of boolean
setup_base_stack_linkers( base_stacks );
setup_arrow_linkers(resnum,chains);
setup_base_pair_linkers( base_pairs );
try_non_standard_names( sequence, resnum, chains, non_standard_residues);

coaxial_stacks = get_coaxial_stacks( base_pairs, base_stacks, stems );
setup_coaxial_stacks( coaxial_stacks );

draw_helices( stems );
setup_zoom();
