function set_ligand_image_color( ligand );
% set_ligand_image_color( ligand )
%
% Grabs rgb_color for ligand (residue object) and sets 
% color of image silhouette as faded version.
%
% (C) R. Das, Stanford University, 2017.

ligand_color = fade_color([0 0 0]);
if isfield( ligand, 'rgb_color')
    ligand_color = fade_color(ligand.rgb_color);
end
set( ligand.image_handle , 'facecolor', fade_color(ligand_color) );
set( ligand.image_handle2, 'facecolor', ligand_color );

