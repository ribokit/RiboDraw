function setup_image_for_ligand( ligand, image_file, new_name, skip_move_stuff_to_back );
% setup_image_for_ligand( ligand, image_file );
%
% INPUTS
%  ligand     = (string) name of ligand/ligand
%  image_file = (image_file) picture of protein. will grab silhouette.
%
% (C) R. Das, Stanford University
[ res_tags, obj_name ] = get_res( ligand );
boundary = get_patch_from_image( image_file, 0 );
ligand = getappdata( gca, obj_name );

boundary = boundary/30;

if isfield( ligand, 'image_handle' ) delete( ligand.image_handle ); end;
if exist( 'new_name', 'var' )
    ligand.nucleotide = new_name;
    if isfield( ligand, 'handle' )  set( ligand.handle, 'String', ligand.nucleotide ); end;
end
ligand.image_boundary = boundary;
ligand = draw_image_boundary( ligand );
setappdata( gca, ligand.res_tag, ligand );
fprintf( 'Setup image %s for %s.\n', image_file, ligand.res_tag );
if ~exist( 'skip_move_stuff_to_back', 'var' )
    move_stuff_to_back();
end
