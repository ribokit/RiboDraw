function convert_undercircle_field_names()
% convert_undercircle_field_names()
%
% Convert legacy 'undercircle_face_color' field of Residues to 'fill_color'. 
% Convert legacy 'undercircle_ring_color' field of Residues to 'ring_color'. 
%
% (C) R. Das, Stanford University, 2019

res_tags = get_res();
num_updates = 0;
for i = 1:length( res_tags )
    updated = 0;
    residue = getappdata( gca, res_tags{i} );
    if isfield( residue, 'undercircle_face_color' )
        residue.fill_color = residue.undercircle_face_color;
        residue = rmfield( residue, 'undercircle_face_color' );
        updated = 1;
    end
    if isfield( residue, 'undercircle_ring_color' )
        residue.ring_color = residue.undercircle_ring_color;
        residue = rmfield( residue, 'undercircle_ring_color' );
        updated = 1;
    end    
    if updated;
        setappdata( gca, res_tags{i}, residue );
        num_updates = num_updates + 1; 
    end
end
if ( num_updates > 0 ); fprintf( 'Name field updated from legacy undercircle_face_color/undercircle_ring_color fields for %d res_tags.\n', num_updates ); end;

