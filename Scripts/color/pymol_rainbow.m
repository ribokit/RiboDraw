function colors = pymol_rainbow( ncolors )
% colors = pymol_rainbow( ncolors )
% (C) R. Das, Stanford University, 2017

% pymol_rainbow.txt is a bunch of RGB colors from applying the
% cmd.spectrum() command to the E. coli ribosome and then pulling out
% RGB values with RiboVis get_residue_colors()
pymol_colors = load( 'pymol_rainbow.txt' );

colors = interp1( [0:(length(pymol_colors)-1)]/(length(pymol_colors)-1),...
                    pymol_colors,[0:(ncolors-1)]/(ncolors-1));
