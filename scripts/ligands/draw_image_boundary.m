function ligand = draw_image_boundary( ligand, plot_settings )
% ligand = draw_image_boundary( ligand, plot_settings )
% 
% Draw the 'silhouette' of a ligand (like a protein) if
%  its image_boundary field has been setup by SETUP_IMAGE_FOR_LIGAND.
%
% Note: this function does not move the image boundary to the back of the
%  drawing -- that needs to be handled by a call to MOVE_STUFF_TO_BACK later.
% 
% (C) Rhiju Das, Stanford University

assert( isfield( ligand, 'image_boundary') );
if ~isfield( plot_settings, 'image_representation' ) plot_settings.image_representation = 'image_boundary'; end;
if ( ~isfield( plot_settings, 'show_images') || plot_settings.show_images );
    if ~isfield( ligand, 'image_offset' ) ligand.image_offset = [0,0]; end;
    switch plot_settings.image_representation
        case 'image_boundary'
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
            if isfield( plot_settings, 'ligand_image_scaling' ) image_boundary = image_boundary * plot_settings.ligand_image_scaling; end;            
            set( ligand.image_handle, ...
                'XData', image_boundary(:,1) + ligand.plot_pos(:,1) + ligand.image_offset(1), ...
                'YData', image_boundary(:,2) + ligand.plot_pos(:,2) + ligand.image_offset(2) );
            set( ligand.image_handle2, ...
                'XData', image_boundary(:,1) + ligand.plot_pos(:,1) + ligand.image_offset(1) + 0.25, ...
                'YData', image_boundary(:,2) + ligand.plot_pos(:,2) + ligand.image_offset(2) - 0.25);
        case 'rounded_rectangle'
            if ( ~isfield( ligand, 'image_handle2' ) | ~isvalid( ligand.image_handle2 ) )
                ligand.image_handle2 = rectangle('position',[0,0,0,0],'curvature',0.5,'edgecolor','none');
                send_to_top_of_back( ligand.image_handle2 );
            end
            if( ~isfield( ligand, 'image_handle' ) | ~isvalid( ligand.image_handle ) )
                ligand.image_handle = rectangle('position',[0,0,0,0],'curvature',0.5,'edgecolor','none');
                send_to_top_of_back( ligand.image_handle );
                setappdata( ligand.image_handle, 'res_tag', ligand.res_tag );
                draggable( ligand.image_handle,'n',[-inf inf -inf inf], @move_snapgrid, 'endfcn', @redraw_res_and_helix );
            end
            
            % should make these user-settable (perhaps by draggable 'image controls')
            ligand.image_radius1 = 2 * std( ligand.image_boundary(:,1) );
            ligand.image_radius2 = 2 * std( ligand.image_boundary(:,2) );
            set( ligand.image_handle,...
                'Position', ...
                [ligand.image_offset(1)+ligand.plot_pos(:,1)-ligand.image_radius1, ligand.image_offset(2)+ligand.plot_pos(:,2)-ligand.image_radius2,...
                 2*ligand.image_radius1,2*ligand.image_radius2 ]);
            set( ligand.image_handle2,...
                'Position', ...
                [ligand.image_offset(1)+ligand.plot_pos(:,1)-(ligand.image_radius1+0.25), ligand.image_offset(2)+ligand.plot_pos(:,2)-(ligand.image_radius2+0.25),...
                 2*(ligand.image_radius1+0.25),2*(ligand.image_radius2+0.25)]);
    end
    set_ligand_image_color( ligand );
    
    if ~isfield( ligand, 'image_label_relpos' ) ligand.image_label_relpos = [0,0]; end;
     if ~isfield( ligand, 'label' ) & isfield( ligand, 'name' )
         %%% TODO -- Need to define a draggable function, etc.
         h = text( 0, 0, ligand.nucleotide, 'fontsize',plot_settings.fontsize*14/10, ....
             'fontweight', 'bold', 'verticalalign','middle','horizontalalign','center','clipping','off' );
         selection.label = h;
         %draggable( h, 'n',[-inf inf -inf inf], @move_selection_label )
         %setappdata( h, 'selection_tag', selection_tag );
         %setappdata( gca, selection_tag, selection );
     end
     if isfield( ligand, 'handle' ) set( ligand.handle, 'visible', 'off'  ); end;
else
    ligand = rmgraphics( ligand, {'image_handle','image_handle2','label'} );
    if isfield( ligand, 'handle' ) 
        set( ligand.handle, 'fontsize',  plot_settings.fontsize*1.5,'visible','on');
    end;
end
   



