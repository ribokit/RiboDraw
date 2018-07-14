%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in rna_motif/, from command_line ran:
%   rna_motif -s 1gid_RNAA.pdb -ignore_zero_occupancy false
% oops forgot to read in stem names
% edited rna_motif/1gid_RNAA.pdb.stems.txt
% Named stem extensions with *

initialize_drawing( 'rna_motif/1gid_RNAA.pdb' );
save_drawing( 'steps/step00_initialize_drawing.mat' );
export_drawing( 'steps/step00_initialize_drawing.png' )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% move around stems
hide_noncanonical_pairs
show_helix_controls
set_artboards
save_drawing( 'steps/step01_movestems.mat' );
export_drawing( 'steps/step01_movestems.png' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a little more flipping to match 'standard' diagram --
%  note will demonstrate how to flip the P5abc domain later.
save_drawing( 'steps/step02_minortweaks.mat' );
export_drawing( 'steps/step02_minortweaks.png' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% build in noncanonical pairs
% zoom in to particular regions
% move linkers.
%
% can associate loop residues with new helices -- show that.
%
% can add joints to linkers by pulling on little circles at residues --
%   show that. 
%  can also remove joints by moving little circles back on to residues --
%  show that.
%
% NOTE NONCANONICAL PAIRS FOR LAST TWO NTS (U259, C260) LOOK MISASSIGNED!
show_noncanonical_pairs
show_linker_controls
color_drawing rainbow
% and in pymol, rrs()
save_drawing( 'steps/step03_P4_P6ab_linkers.mat' );
export_drawing( 'steps/step03_step03_P4_P6ab_linkers.png' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 4A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zoom out (double click with magnifying glass icon)
 slice_drawing( 'A:127-195' )
% Will get:
% Warning! slice_res only catches part of helix Helix_A127. Will include the rest of that helix too
color_drawing rainbow
set_artboards
hide_helix_label( 'P5a*' );
hide_helix_label( 'P5a**' );

save_drawing( 'steps/step04A_P5abc_slice.mat' );
export_drawing( 'steps/step04A_P5abc_slice.png' );

% in pymol 
%  color white
%  rrs( 'chain A and resi 127-195')
% hide ev, not (chain A and resi 127-195)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 4B -- fine scale fixup of P5abc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% G156 -- associate with P5b.
save_drawing( 'steps/step04B_P5abc_refine_slice.mat' );
export_drawing( 'steps/step04B_P5abc_refine_slice.png' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 4C -- merge drawing back in
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
merge_drawing( 1 );
set_artboards
save_drawing( 'steps/step04C_P5abc_merge_slice.mat' );
export_drawing( 'steps/step04C_P5abc_merge_slice.png' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 5 -- flip P5abc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setup_domain(  'A:127-195','P5abc' )
list_domains
hide_domain_label( 'P5abc' )
%
%*P5abc (Selection_P5abc_domain)
%
% * = label visible.
%
list_domains
% P5abc (Selection_P5abc_domain)
%
%* = label visible.

show_domain_controls
% flipped it.
color_drawing rainbow
save_drawing( 'steps/step05_flipP5abc.mat' );
export_drawing( 'steps/step05_flipP5abc.png' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 6 -- the rest of the linkers
% also rainbow-colored pymol
% rrs()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hide_helix_label( 'P4*')
hide_domain_controls
save_drawing( 'steps/step06_refineall.mat' );
export_drawing( 'steps/step06_refineall.png' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 7 -- some recoloring in both ribodraw and pymol
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hide_linker_controls
hide_helix_controls
color_drawing gray
color_drawing marine P5abc 
setup_domain(  'A:122-198','P5abc' ); % expand P5abc to encompass whole 'left hand' of drawing
color_drawing marine P5abc 
setup_domain(  'A:107-121 A:199-214','P4P5' );
color_drawing purple P4P5 
setup_domain(  'A:220-253','P6' ); 
color_drawing forest P6 
hide_domain_label( 'P5abc' );
hide_domain_label( 'P4P5' );
hide_domain_label( 'P6' );

% and in pymol
% color gray
% select P5abc, resi 122-198
% select P4P5, resi 107-121 or resi 199-214
% select P6, resi 220-253
% color marine, P5abc
% color purple, P4P5
% color forest, P6
% hide spheres
% save /Users/rhiju/Desktop/1gid_RNAA.pse  
save_drawing( 'steps/step07_final.mat' );
export_drawing( 'steps/step07_final.png' );

save_drawing( '1gidA_drawing.mat' );
export_drawing( '1gidA_drawing.png' );




