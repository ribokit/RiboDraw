function draw_selections( selections );

plot_settings = getappdata( gca, 'plot_settings' );
if ~isfield( plot_settings, 'show_coax_controls' ) & isfield( plot_settings, 'show_selection_controls' )
    plot_settings.show_coax_controls   = plot_settings.show_selection_controls;
    plot_settings.show_domain_controls = plot_settings.show_selection_controls;
    rmfield( plot_settings, 'show_selection_controls' );
    setappdata( gca, 'plot_settings', plot_settings );
end

spacing = plot_settings.spacing;
for i = 1:length( selections )
    selection_tag = selections{i};
    if ~isappdata( gca, selection_tag ); fprintf( 'Problem with %s\n', selection_tag ); continue; end; % some cleanup
    selection = getappdata( gca, selection_tag );
    dom_pos = [];
    for j = 1:length( selection.associated_residues )
        residue = getappdata( gca, selection.associated_residues{j} );
        if isfield( residue, 'plot_pos' );
            dom_pos = [ dom_pos; residue.plot_pos ];
        end
    end
    minpos = min( dom_pos, [], 1 );
    maxpos = max( dom_pos, [], 1 );  
    ctr_pos = (minpos + maxpos )/ 2;
    if ( plot_settings.show_coax_controls )
        selection = create_default_rectangle( selection, 'selection_tag', selection_tag, @redraw_selection );
        if strcmp( selection.type, 'coaxial_stack' )
            set( selection.rectangle,'edgecolor',[1 0.7 0.7]);
            if  ~isfield( selection, 'auto_text' )
                h = text( 0, 0, 'auto', 'fontsize',plot_settings.fontsize*6/10,...
                    'color',[1 0.7 0.7],'verticalalign','top','clipping','off');
                setappdata(h,'selection_tag',selection_tag);
                set(h,'ButtonDownFcn',{@autoformat_coaxial_stack,h});
                selection.auto_text = h;
                setappdata( gca, selection_tag, selection );
            end
        end
    end
    if ( plot_settings.show_domain_controls )
        selection = create_default_rectangle( selection, 'selection_tag', selection_tag, @redraw_selection );
        if strcmp( selection.type, 'domain' ) 
            domain_color = [1 0.4 0.4];
            if isfield( selection, 'rgb_color' ) domain_color = selection.rgb_color; end;
            set( selection.rectangle,'edgecolor',domain_color); 
            if ~isfield( selection, 'label_relpos' ) selection.label_relpos = minpos - ctr_pos; end;
            if ( plot_settings.show_selection_controls ) visible = 'on'; else; visible = 'off'; end;
            set( selection.rectangle, 'visible', visible );
            if ~isfield( selection, 'label' ) & isfield( selection, 'name' )
                h = text( 0, 0, selection.name, 'fontsize',plot_settings.fontsize*14/10, ....
                    'fontweight', 'bold', 'verticalalign','middle','horizontalalign','center','clipping','off' );
                selection.label = h;
                draggable( h, 'n',[-inf inf -inf inf], @move_selection_label )
                setappdata( h, 'selection_tag', selection_tag );
                setappdata( gca, selection_tag, selection );
            end            
            if ~isfield( selection,'reflect_line_horizontal1' )
                % for domain: clickable lines of reflection
                line1 =  [minpos(1) ctr_pos(2)] + [0,-spacing/2];
                line1x = [minpos(1) ctr_pos(2)] + [0,+spacing/2];
                h = plot( [0 0], [1 1], 'color',[1 0.5 0.5],'clipping','off' );
                setappdata( h, 'selection_tag', selection_tag);
                setappdata( h, 'reflect_axis', 'horizontal');
                set(h,'ButtonDownFcn',{@reflect_selection,h});
                selection.reflect_line_horizontal1 = h;
            end
            if ~isfield( selection,'reflect_line_horizontal2' )
                % for domain: clickable lines of reflection
                line2 =  [maxpos(1) ctr_pos(2)] + [0,-spacing/2];
                line2x = [maxpos(1) ctr_pos(2)] + [0,+spacing/2];
                h = plot( [0 0], [1 1], 'color',[1 0.5 0.5],'clipping','off' );
                setappdata( h, 'selection_tag', selection_tag);
                setappdata( h, 'reflect_axis', 'horizontal');
                set(h,'ButtonDownFcn',{@reflect_selection,h});
                selection.reflect_line_horizontal2 = h;
            end
            
%             line2 = helix_center + spacing*[ (N+0.25)/2, 0]*R;
%             line2x = helix_center + spacing*[ (N-0.75)/2, 0]*R;
%             h = plot( [line2(1),line2x(1)], [line2x(2), line2(2)], 'color',[0.5 0.5 1],'clipping','off' );
%             setappdata( h, 'helix_tag', helix.helix_tag);
%             set(h,'ButtonDownFcn',{@reflect_helix,h});
%             selection.reflect_line_horizontal_2 = h;
             
%             % for helix: clickable center of rotation
%             h = rectangle( 'Position',...
%                 [0 0,...
%                 0.3*spacing 0.3*spacing], ...
%                 'curvature',[0.5 0.5],...
%                 'edgecolor',[0.5 0.5 1],...
%                 'facecolor',[0.5 0.5 1],'linewidth',1.5,'clipping','off' );
%             setappdata( h,'helix_tag', helix.helix_tag);
%             set(h,'ButtonDownFcn',{@rotate_helix,h});
%             helix.click_center = h;

        end
    end
    if isfield( selection, 'rectangle') set_rectangle_coords( selection, minpos, maxpos, spacing ); end;
    if isfield( selection, 'auto_text') set( selection.auto_text, 'Position',  minpos + [-0.5 -0.5]*0.75*spacing ); end
    if isfield( selection, 'label') 
        set( selection.label, 'Position',  ctr_pos + selection.label_relpos ); 
        if isfield( selection, 'rgb_color' ) set( selection.label, 'color', selection.rgb_color ); end
    end
    if isfield( selection, 'reflect_line_horizontal1' );
        % pos
    end
end
