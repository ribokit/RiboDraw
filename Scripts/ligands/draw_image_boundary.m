function ligand = draw_image_boundary( ligand )

assert( isfield( ligand, 'image_boundary') );
if ( ~isfield( ligand, 'image_handle2' ) | ~isvalid( ligand.image_handle2 ) )
    ligand.image_handle2 = patch(0,0,[0,0,0],'edgecolor','none');
    send_to_top_of_back( ligand.image_handle2 );
end
if( ~isfield( ligand, 'image_handle' ) | ~isvalid( ligand.image_handle ) )
    ligand.image_handle = patch(0,0,[0,0,0],'edgecolor','none');
    send_to_top_of_back( ligand.image_handle );
end

set( ligand.image_handle, ...
    'XData', ligand.image_boundary(:,1) + ligand.plot_pos(:,1), ...
    'YData', ligand.image_boundary(:,2) + ligand.plot_pos(:,2) );
set( ligand.image_handle2, ...
    'XData', ligand.image_boundary(:,1) + ligand.plot_pos(:,1) + 0.25, ...
    'YData', ligand.image_boundary(:,2) + ligand.plot_pos(:,2) - 0.25);
set_ligand_image_color( ligand );

set_ligand_image_color( ligand );

