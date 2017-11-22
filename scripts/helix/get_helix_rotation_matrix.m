function R = get_helix_rotation_matrix( helix )
% R = get_helix_rotation_matrix( helix )
%
% return 2x2 rotation matrix given theta and parity stored in helix object.
%
% (C) R. Das, Stanford University, 2017.

theta = helix.rotation;
R = [cos(theta*pi/180) -sin(theta*pi/180);sin(theta*pi/180) cos(theta*pi/180)];
R = [1 0; 0 helix.parity] * R;
