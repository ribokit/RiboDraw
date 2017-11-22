function setup_image_for_ligand( ligand, image_file, new_name, skip_move_stuff_to_back );
% setup_image_for_ligand( ligand, image_file );
%
% Useful helper function: reads in a .png or .jpg image file for a protein or other ligand and any new name to
%   display for the ligand.
%
% INPUTS
%  ligand     = (string) name of ligand/ligand
%  image_file = (image_file) picture of protein. will grab silhouette.
%  new_name   = [optional] change display name of ligand to this. [default: don't change name]
%  skip_move_stuff_to_back = don't do the time-consuming move stuff to back, 
%                             assuming that user will run MOVE_STUFF_TO_BACK separately. [default 1]
%
% (C) R. Das, Stanford University

[ res_tags, obj_name ] = get_res( ligand );
boundary = get_patch_from_image( image_file, 0 );
ligand = getappdata( gca, obj_name );

boundary = boundary/30;

if isfield( ligand, 'image_handle' ) delete( ligand.image_handle ); end;
if exist( 'new_name', 'var' ) && length( new_name ) > 0
    % uh probably should change the name of the nucleotide field to 'name'
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
