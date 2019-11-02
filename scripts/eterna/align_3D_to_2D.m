function coords3Dt = align_3D_to_2D( coords3D, coords2D );
% coords3Dt = align_3D_to_2D( coords3D, coords2D );

coords2D(:,3)=0.0;

% let's scale, rotate, and translate 3D coords to better match 2D.
coords3Dc = coords3D-mean(coords3D);
sf = sqrt( mean( coords2D.^2)/ mean( coords3Dc.^2 ));
coords3Ds = coords3Dc * sf;

[U,r,lrms] = Kabsch( coords3Ds', coords2D');
coords3Dt = (U * coords3Ds' + r)';
