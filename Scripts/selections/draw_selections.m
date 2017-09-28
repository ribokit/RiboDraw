function draw_selections( selections );

plot_settings = getappdata( gca, 'plot_settings' );
if ~isfield( plot_settings, 'show_coax_controls' ) & isfield( plot_settings, 'show_selection_controls' )
    plot_settings.show_coax_controls   = plot_settings.show_selection_controls;
    plot_settings.show_domain_controls = plot_settings.show_selection_controls;
    plot_settings = rmfield( plot_settings, 'show_selection_controls' );
    setappdata( gca, 'plot_settings', plot_settings );
end

spacing = plot_settings.spacing;
for i = 1:length( selections )
    selection_tag = selections{i};
    if ~isappdata( gca, selection_tag ); fprintf( 'Problem with %s\n', selection_tag ); continue; end; % some cleanup
    selection = getappdata( gca, selection_tag );
    [minpos,maxpos] = get_minpos_maxpos( selection );  
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
            if ( plot_settings.show_domain_controls ) visible = 'on'; else; visible = 'off'; end;
            set( selection.rectangle, 'visible', visible );
            if ~isfield( selection, 'label' ) & isfield( selection, 'name' )
                h = text( 0, 0, selection.name, 'fontsize',plot_settings.fontsize*14/10, ....
                    'fontweight', 'bold', 'verticalalign','middle','horizontalalign','center','clipping','off' );
                selection.label = h;
                draggable( h, 'n',[-inf inf -inf inf], @move_selection_label )
                setappdata( h, 'selection_tag', selection_tag );
                setappdata( gca, selection_tag, selection );
            end
            
            % for domain: clickable lines of reflection
            selection = create_clickable_reflection_line( 'reflect_line_horizontal1', selection );
            selection = create_clickable_reflection_line( 'reflect_line_horizontal2', selection  );
            selection = create_clickable_reflection_line( 'reflect_line_vertical1', selection  );
            selection = create_clickable_reflection_line( 'reflect_line_vertical2', selection  );
            % for domain: clickable center of rotation
            if ~isfield( selection, 'click_center' );
                h = rectangle( 'Position',...
                    [0 0,0,0],'curvature',[0.5 0.5],'edgecolor',[0.5 0.5 1],'facecolor',[0.5 0.5 1],'linewidth',1.5,'clipping','off' );
                setappdata( h,'selection_tag', selection_tag);
                set(h,'ButtonDownFcn',{@rotate_selection,h});
                selection.click_center = h;
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
    if isfield( selection, 'reflect_line_horizontal1' );
        set( selection.reflect_line_horizontal1, 'Xdata', minpos(1) + 0.75*spacing * ( -0.5 + [-0.5,0.5]), 'Ydata', ctr_pos(2) * [1 1] );
        if isfield( selection, 'rgb_color' ) set( selection.reflect_line_horizontal1, 'color', selection.rgb_color ); end
    end
    if isfield( selection, 'reflect_line_horizontal2' );
        set( selection.reflect_line_horizontal2, 'Xdata', maxpos(1) + 0.75*spacing * ( +0.5 + [-0.5,0.5]), 'Ydata', ctr_pos(2) * [1 1] );
        if isfield( selection, 'rgb_color' ) set( selection.reflect_line_horizontal2, 'color', selection.rgb_color ); end
    end
    if isfield( selection, 'reflect_line_vertical1' );
        set( selection.reflect_line_vertical1, 'Ydata', minpos(2) + 0.75*spacing * ( -0.5 + [-0.5,0.5]), 'Xdata', ctr_pos(1) * [1 1] );
        if isfield( selection, 'rgb_color' ) set( selection.reflect_line_vertical1, 'color', selection.rgb_color ); end
    end
    if isfield( selection, 'reflect_line_vertical2' );
        set( selection.reflect_line_vertical2, 'Ydata', maxpos(2) + 0.75*spacing * ( +0.5 + [-0.5,0.5]), 'Xdata', ctr_pos(1) * [1 1] );
        if isfield( selection, 'rgb_color' ) set( selection.reflect_line_vertical2, 'color', selection.rgb_color ); end
    end
    if isfield( selection, 'click_center' );
        set( selection.click_center, 'Position', [ctr_pos(1)-0.15*spacing ctr_pos(2)-0.15*spacing,...
            0.3*spacing 0.3*spacing] );
        if isfield( selection, 'rgb_color' ) set( selection.click_center, 'edgecolor', selection.rgb_color ); end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function selection = create_clickable_reflection_line( tag, selection );

if isfield( selection, tag ); return; end;

h = plot( [0 0], [1 1], 'color',[1 0.5 0.5],'clipping','off' );
setappdata( h, 'selection_tag', selection.selection_tag);

flip = 'vertical';
% if lines are horizontal, reflection looks like up/down flip.
if ~isempty( strfind( tag, 'vertical' ) ) flip = 'horizontal';end;

setappdata( h, 'flip', flip);
set(h,'ButtonDownFcn',{@reflect_selection,h});
selection = setfield( selection, tag, h );
setappdata( gca, selection.selection_tag, selection );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [minpos,maxpos] = get_minpos_maxpos( selection );  
dom_pos = [];
for j = 1:length( selection.associated_residues )
    residue = getappdata( gca, selection.associated_residues{j} );
    if isfield( residue, 'plot_pos' );
        dom_pos = [ dom_pos; residue.plot_pos ];
    end
end
minpos = min( dom_pos, [], 1 );
maxpos = max( dom_pos, [], 1 );
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function reflect_selection( h, ~, ~ )
selection_tag = getappdata( h, 'selection_tag' );
flip = getappdata( h, 'flip' );
selection = getappdata(gca,selection_tag );
[residues, associated_helices] = get_res_helix_for_selection( selection );

[minpos,maxpos] = get_minpos_maxpos( selection );  
for i = 1:length( associated_helices )
    helix = getappdata( gca, associated_helices{i} );

    theta = helix.rotation;
    R = [cos(theta*pi/180) -sin(theta*pi/180);sin(theta*pi/180) cos(theta*pi/180)];
    R = [1 0; 0 helix.parity] * R;
    if strcmp( flip, 'horizontal' )
        helix.center(1) = (maxpos(1) - helix.center(1)) + minpos(1);
        R = R * [-1 0; 0 1];
    else
        assert( strcmp( flip, 'vertical' ) );
        helix.center(2) = (maxpos(2) - helix.center(2)) + minpos(2);
        R = R * [1 0; 0 -1];
    end
    
    helix.parity = helix.parity * -1; % there will definitely be a flip.
    R = [1 0; 0 helix.parity] * R; % what flip looks like in 'lab frame' not helix frame
    helix.rotation = round( atan2( R(2,1), R(1,1) ) * 180/pi );

    setappdata( gca, associated_helices{i}, helix );
    draw_helix( helix );
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rotate_selection( h, ~, ~ )
selection_tag = getappdata( h, 'selection_tag' );
selection = getappdata(gca,selection_tag );
[residues, associated_helices] = get_res_helix_for_selection( selection );

[minpos,maxpos] = get_minpos_maxpos( selection );  
ctr_pos = ( minpos + maxpos ) / 2;
for i = 1:length( associated_helices )
    helix = getappdata( gca, associated_helices{i} );
    helix.center = ( helix.center - ctr_pos ) * [0 -1; 1 0] + ctr_pos;
    helix.rotation = mod( helix.rotation + 90, 360 );
    setappdata( gca, associated_helices{i}, helix );
    draw_helix( helix );
end


