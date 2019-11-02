%%
figure(1); load_drawing( '16S_drawing_eterna_theme.mat')
coords2D = get_coords2D();

%%
[coords3D,resName,resSeq] = get_coords3D('../rna_motif/4ybb_16S.pdb');

%%
coords3Dt = align_3D_to_2D( coords3D, coords2D );

%%
figure(2); clf;
plot3( coords3Dt(:,1),coords3Dt(:,2),coords3Dt(:,3),'-')
hold on
plot( coords2D(:,1),coords2D(:,2),'-'); 
axis equal
axis vis3d;

%%
morph_2D_to_3D( coords2D, coords3Dt, resname );
