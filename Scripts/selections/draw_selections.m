function draw_selections( selections );

plot_settings = getappdata( gca, 'plot_settings' );
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
    if ( plot_settings.show_selection_controls | strcmp( selection.type, 'domain' ) )
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
        if strcmp( selection.type, 'domain' ) 
            set( selection.rectangle,'edgecolor',[1 0.4 0.4]); 
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
        end
    end
    if isfield( selection, 'rectangle') set_rectangle_coords( selection, minpos, maxpos, spacing ); end;
    if isfield( selection, 'auto_text') set( selection.auto_text, 'Position',  minpos + [-0.5 -0.5]*0.75*spacing ); end
    if isfield( selection, 'label') 
        set( selection.label, 'Position',  ctr_pos + selection.label_relpos ); 
        if isfield( selection, 'rgb_color' ) set( selection.label, 'color', selection.rgb_color ); end
    end
end
