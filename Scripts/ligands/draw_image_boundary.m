function ligand = draw_image_boundary( ligand )

assert( isfield( ligand, 'image_boundary') );
if ( ~isfield( ligand, 'image_handle2' ) | ~isvalid( ligand.image_handle2 ) )
    ligand.image_handle2 = patch(0,0,[0,0,0],'edgecolor','none');
    send_to_top_of_back( ligand.image_handle2 );
end
if( ~isfield( ligand, 'image_handle' ) | ~isvalid( ligand.image_handle ) )
    ligand.image_handle = patch(0,0,[0,0,0],'edgecolor','none');
    send_to_top_of_back( ligand.image_handle );
    setappdata( ligand.image_handle, 'res_tag', ligand.res_tag );
    draggable( ligand.image_handle,'n',[-inf inf -inf inf], @move_snapgrid, 'endfcn', @redraw_res_and_helix );
end

image_boundary = ligand.image_boundary;

plot_settings = getappdata( gca, 'plot_settings' );
if isfield( plot_settings, 'ligand_image_scaling' ) image_boundary = image_boundary * plot_settings.ligand_image_scaling; end;

set( ligand.image_handle, ...
    'XData', image_boundary(:,1) + ligand.plot_pos(:,1), ...
    'YData', image_boundary(:,2) + ligand.plot_pos(:,2) );
set( ligand.image_handle2, ...
    'XData', image_boundary(:,1) + ligand.plot_pos(:,1) + 0.25, ...
    'YData', image_boundary(:,2) + ligand.plot_pos(:,2) - 0.25);

set_ligand_image_color( ligand );
   
if isfield( ligand, 'handle' )  set( ligand.handle, 'fontsize',  plot_settings.fontsize*1.5  ); end;

