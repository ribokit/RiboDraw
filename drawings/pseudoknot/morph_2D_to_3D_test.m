%%
figure(1);
coords2D = get_coords2D( 'drawing.mat' );

%%
[coords3D,resname] = get_coords3D('rna_motif/1l2x.pdb');

%%
figure(2); clf;
coords3D = coords3D - mean( coords3D );
plot3( coords3D(:,1),coords3D(:,2),coords3D(:,3),'o-')
hold on
plot( coords2D(:,1),coords2D(:,2),'o-'); axis vis3d;

%%
morph_2D_to_3D( coords2D, coords3D, resname );
