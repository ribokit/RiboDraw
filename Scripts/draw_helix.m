function helix = draw_helix( helix )
% helix = draw_helix( helix )
% (C) R. Das, Stanford University, 2017

plot_settings = getappdata( gca, 'plot_settings' );

helix_center = helix.center;
R = get_helix_rotation_matrix( helix ); 
N = length( helix.resnum1 );

spacing = plot_settings.spacing;
bp_spacing = plot_settings.bp_spacing;
helix_res_tags = {};
for k = 1:N
    % first partner of base pair -- will draw below.
    res_tag = sprintf( 'Residue_%s%d', helix.chain1(k), helix.resnum1(k) );
    pos1 = update_residue_pos( res_tag, [ spacing*((k-1)-(N-1)/2), -bp_spacing/2], helix.center, R );
    helix_res_tags = [helix_res_tags, res_tag ];

    % second partner of base pair -- will draw below.
    res_tag = sprintf( 'Residue_%s%d', helix.chain2(N-k+1), helix.resnum2(N-k+1) );
    pos2 = update_residue_pos( res_tag, [ spacing*((k-1)-(N-1)/2), +bp_spacing/2], helix.center, R );
    helix_res_tags = [helix_res_tags, res_tag ];
 
    all_pos1(k,:) = pos1;
    all_pos2(k,:) = pos2;
end

% draw all residues that are associated with the helix 
not_helix_res_tags = {};
for i = 1:length( helix.associated_residues )
    res_tag = helix.associated_residues{i};
    residue = getappdata( gca, res_tag );
    if ~isfield( residue, 'relpos' ) 
        residue.relpos = set_default_relpos( residue, helix, plot_settings ); 
        setappdata( gca, res_tag, residue );
    end;
    draw_residue( res_tag, helix_center, R, plot_settings );
    if ~any(strcmp(  helix_res_tags, res_tag )) not_helix_res_tags = [not_helix_res_tags, res_tag]; end;
end

% update any linkers associated with these residues
% in the future, these could include base pairs (incl. non-canonicals)
redrawn_linkers = {};
for i = 1:length( helix.associated_residues )
    res_tag = helix.associated_residues{i};
    residue = getappdata( gca, res_tag );
    linker_tags = residue.linkers;
    % silly cleanup
    for k = 1 : length( linker_tags )
        if any( strcmp( redrawn_linkers, linker_tags{k} ) ); continue; end; % don't double-render, to save time.
        linker = getappdata( gca, linker_tags{k} );
        draw_linker( linker );
        redrawn_linkers = [ redrawn_linkers, linker.linker_tag ];
    end
end

if ~isfield( helix, 'label_relpos' ) helix.label_relpos = plot_settings.bp_spacing *[0 1]; end;
helix.l = make_helix_label( helix, plot_settings, R );

% handles for helix editing
% rectangle for dragging.
minpos = min( [all_pos1; all_pos2 ] );
maxpos = max( [all_pos1; all_pos2 ] );
h = rectangle( 'Position',...
    [minpos(1) minpos(2) maxpos(1)-minpos(1) maxpos(2)-minpos(2) ]+...
    [-0.5 -0.5 1 1]*0.75*spacing,...
    'edgecolor',[0.5 0.5 1],'clipping','off');
setappdata(h,'helix_tag',helix.helix_tag); 
draggable(h,'n',[-inf inf -inf inf],@move_snapgrid,'endfcn',@redraw_helix);
helix.helix_rectangle = h;

% clickable line of reflection
line1 = helix_center + spacing*[-(N+0.25)/2, 0]*R;
line1x = helix_center + spacing*[-(N-0.75)/2, 0]*R;
h = plot( [line1(1),line1x(1)], [line1(2), line1x(2)], 'color',[0.5 0.5 1],'clipping','off' );
setappdata( h, 'helix_tag', helix.helix_tag);
set(h,'ButtonDownFcn',{@reflect_helix,h});
helix.reflect_line1 = h;

line2 = helix_center + spacing*[ (N+0.25)/2, 0]*R;
line2x = helix_center + spacing*[ (N-0.75)/2, 0]*R;
h = plot( [line2(1),line2x(1)], [line2x(2), line2(2)], 'color',[0.5 0.5 1],'clipping','off' );
setappdata( h, 'helix_tag', helix.helix_tag);
set(h,'ButtonDownFcn',{@reflect_helix,h});
helix.reflect_line2 = h;

% clickable center of rotation
h = rectangle( 'Position',...
    [helix_center(1)-0.15*spacing helix_center(2)-0.15*spacing,...
    0.3*spacing 0.3*spacing], ...
    'curvature',[0.5 0.5],...
    'edgecolor',[0.5 0.5 1],...
    'facecolor',[0.5 0.5 1],'linewidth',1.5,'clipping','off' );
setappdata( h,'helix_tag', helix.helix_tag);
set(h,'ButtonDownFcn',{@rotate_helix,h});
helix.click_center = h;

% make ticklabels draggable
for i = 1:length( helix.associated_residues )
    res_tag = helix.associated_residues{i};
    residue = getappdata( gca, res_tag );
    if isfield( residue, 'tick_label' )
        setappdata( residue.tick_label, 'res_tag', res_tag );
        draggable( residue.tick_label, @move_tick, 'endfcn', @redraw_tick_res_and_helix );
    end
end

% make single-stranded residues draggable...
for i = 1:length( not_helix_res_tags )
    res_tag = not_helix_res_tags{i};
    residue = getappdata( gca, res_tag );
    draggable( residue.handle,@move_snapgrid, 'endfcn', @redraw_res_and_helix )
end

% draggable helix label
setappdata( helix.l, 'helix_tag', helix.helix_tag );
draggable( helix.l, 'n',[-inf inf -inf inf], @move_helix_label, 'endfcn', @redraw_helix_label )

% draggable linker vertices
for i = 1:length( helix.associated_residues )
    res_tag = helix.associated_residues{i};
    residue = getappdata( gca, res_tag );
    linker_tags = residue.linkers;
    for k = 1 : length( linker_tags )
        linker = getappdata( gca, linker_tags{k} );
        if ~isfield( linker, 'line_handle' ) continue; end;
        if strcmp(linker.type,'stem_pair'); continue; end;
        if ~strcmp(get(linker.line_handle,'visible'),'on'); continue; end;
        if ~isfield( linker, 'vtx' ) 
            linker.vtx = {}; 
            nvtx = size(linker.plot_pos,1);
            linker.vtx{1}  = create_endpoint_linker_vertex(linker.plot_pos(1,:), linker.linker_tag ); 
            for i = 2:(nvtx-1)
                linker.vtx{i}  = create_draggable_linker_vertex(linker.plot_pos(i,:), linker.linker_tag  );
            end
            linker.vtx{nvtx}  = create_endpoint_linker_vertex( linker.plot_pos(nvtx,:), linker.linker_tag ); 
        end;
        for i = 1:size( linker.plot_pos, 1 )
            set( linker.vtx{i}, 'xdata', linker.plot_pos(i,1), 'ydata', linker.plot_pos(i,2) );
        end
        setappdata(gca, linker.linker_tag, linker ); 
    end
end

%%%%%%%%%%%%%%%%%%%%%
% DO THIS AT THE END
%%%%%%%%%%%%%%%%%%%%%
% 'global data' (stored in figure)
setappdata( gca, helix.helix_tag, helix );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Residue 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = draw_residue( res_tag, helix_center, R, plot_settings );
residue = getappdata( gca, res_tag );
if isfield( residue, 'relpos' )
    pos = helix_center +  residue.relpos * R ;
    if ~isfield( residue, 'handle' )
        residue.handle = text( ...
            0, 0,...
            residue.nucleotide,...
            'fontsize', plot_settings.fontsize, ...
            'fontname','helvetica','horizontalalign','center','verticalalign','middle',...
            'clipping','off');
    end
    h = residue.handle;
    set( h, 'Position', pos );
    if ( length( residue.nucleotide ) > 1 ) set( h, 'fontsize', plot_settings.fontsize*4/5); end;
    setappdata( residue.handle, 'res_tag', res_tag );
    residue.res_tag = res_tag;
    residue.plot_pos = pos;
    residue = draw_tick( residue, plot_settings.bp_spacing, R );
    if isfield( residue, 'rgb_color' ) set(h,'color',residue.rgb_color ); end;
    % quick linker cleanup
    if isfield( residue, 'linkers' );
        linker_tags = residue.linkers;
        for k = 1 : length( linker_tags );  ok_linker(k) = isappdata( gca, linker_tags{k} );     end
        residue.linkers = linker_tags( ok_linker );
    end
    setappdata( gca, res_tag, residue );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function move_snapgrid(h)
% snap to grid during movement.
% show crosshairs too

% works for both text (residue) and rectangle (helix).
if strcmp( h.Type, 'line' )
    % line/symbol
    pos = [ get( h, 'XData' ), get( h, 'YData' ) ];
    res_center = pos;
else
    pos = get(h,'Position');
    if length( pos ) == 4 % rectangle
        res_center = [pos(1)+pos(3)/2, pos(2)+pos(4)/2];
    else
        res_center = pos(1:2); % text
    end
end

% Computing the new position of the rectangle
plot_settings = getappdata(gca,'plot_settings');
grid_spacing = plot_settings.spacing/4;
new_position = round(res_center/grid_spacing)*grid_spacing;

% Updating the rectangle' XData and YData properties
delta = new_position - res_center;
pos(1:2) = pos(1:2) + delta;

if strcmp( h.Type, 'line' )
    set(h,'XData',pos(1),'YData',pos(2) );
else
    set(h,'Position',pos );    
end

make_crosshair( pos );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function relpos = set_default_relpos( residue, helix, plot_settings )
% need to find which helix st;rand to append to, and then go out a bit.
dist1 = min( abs(helix.resnum1 - residue.resnum) );
if ( residue.chain ~= helix.chain1(1) ) dist1 = Inf * dist1; end;
dist2 = min( abs(helix.resnum2 - residue.resnum) );
if ( residue.chain ~= helix.chain2(1) ) dist2 = Inf * dist2; end;
[~,strand] = min( [min( dist1 ), min( dist2 )] );
N = length( helix.resnum1 );
if ( strand == 1 )   
    relpos = [ plot_settings.spacing*(+(residue.resnum-helix.resnum1(1))-(N-1)/2), -plot_settings.bp_spacing/2];
else
    assert( strand == 2 );    
    relpos = [ plot_settings.spacing*(-(residue.resnum-helix.resnum2(1))+(N-1)/2), +plot_settings.bp_spacing/2];  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pos = update_residue_pos( res_tag, relpos, center, R );
residue = getappdata( gca, res_tag );
residue.relpos = relpos;
pos = center + relpos*R;
setappdata( gca, res_tag, residue);
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helix label
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = make_helix_label( helix, plot_settings, R )
% make label
label_pos = helix.center + helix.label_relpos * R;
h = text( label_pos(1), label_pos(2), helix.name,...
    'fontsize', plot_settings.fontsize*1.5, 'fontname','helvetica','clipping','off');
v = [0,sign(helix.label_relpos(2))]*R;
set_text_alignment( h, v );
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function move_helix_label(h)
pos = get(h,'position'); 
helix_tag = getappdata( h, 'helix_tag' );
helix = getappdata( gca, helix_tag );
R = get_helix_rotation_matrix( helix );
relpos = (pos(1:2) - helix.center)*R';
v = [0,sign(relpos(2))]*R;
set_text_alignment( h, v );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function redraw_helix_label(h)

pos = get(h,'position'); 
helix_tag = getappdata( h, 'helix_tag' );
helix = getappdata( gca, helix_tag );

% need to figure out rel_pos back in the 'frame' of the helix.
% for that I need to figure out rotation matrix.
R = get_helix_rotation_matrix( helix );
helix.label_relpos = ( pos(1:2) - helix.center ) * R';

% snap to grid?
plot_settings = getappdata( gca, 'plot_settings' );
snap_spacing = plot_settings.bp_spacing/4;
helix.label_relpos = round( helix.label_relpos / snap_spacing ) * snap_spacing;

delete( h );
undraw_helix( helix );
draw_helix( helix );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_text_alignment( h, v )

theta = atan2( v(2), v(1) );
theta =  45 * round( (theta * 180/pi)/45 );
theta = mod( theta, 360 );
switch theta
    case 0
        set( h,'horizontalalign','left','verticalalign','middle');
    case 45
        set( h,'horizontalalign','left','verticalalign','bottom');
    case 90
        set( h,'horizontalalign','center','verticalalign','bottom');
    case 135
        set( h,'horizontalalign','right','verticalalign','bottom');
    case 180
        set( h,'horizontalalign','right','verticalalign','middle'); 
    case 225
        set( h,'horizontalalign','right','verticalalign','top'); 
    case 270
        set( h,'horizontalalign','center','verticalalign','top');
    case 315
        set( h,'horizontalalign','left','verticalalign','top'); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linkers (base pairs & arrow connectors)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function linker = set_linker_endpos( linker, res_tag, relpos_field, at_start );
if ~isfield( linker, relpos_field )
    linker = setfield( linker, relpos_field, [0,0]);
end;
relpos = getfield( linker, relpos_field );
residue = getappdata( gca, res_tag );
if isfield( residue,'relpos' )
    if ( at_start > 0) relpos(1,:)   = residue.relpos;
    else               relpos(end,:) = residue.relpos;
    end
end
linker = setfield( linker, relpos_field, relpos);
setappdata( gca, linker.linker_tag, linker );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_arrow( h, ctr, v, visible, spacing );
x = v * [0 1; -1 0]; % cross direction
set( h, 'visible', visible);
a1 = ctr - spacing/3*v-spacing/5*x;
a2 = ctr - spacing/3*v+spacing/5*x;
a3 = ctr - spacing/6*v+spacing/10*x;
a4 = ctr + spacing/2*v;
a5 = ctr - spacing/6*v-spacing/10*x;
set( h, 'xdata', ...
    [a1(1) a2(1) a3(1) a4(1) a5(1)] );
set( h, 'ydata', ...
    [a1(2) a2(2) a3(2) a4(2) a5(2)] );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pos1 = nudge_pos( pos1, pos2, bp_spacing );
v = pos2 - pos1; 
v = v/norm(v);
pos1 = pos1 +  (bp_spacing/5)*v;
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_pos = get_plot_pos( res_tag, relpos );
residue = getappdata( gca, res_tag );
helix = getappdata( gca, residue.helix_tag );
R = get_helix_rotation_matrix( helix );
plot_pos = repmat(helix.center,size(relpos,1),1) + relpos*R;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function relpos = get_relpos_based_on_restag( plot_pos, res_tag );
residue = getappdata( gca, res_tag );
helix = getappdata( gca, residue.helix_tag );
relpos = get_relpos( plot_pos, helix );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function linker = draw_linker( linker )
% the rendering in this function  ends up being rate limiting for
% draw_helix -- early return if we don't have to make anything
plot_settings = getappdata( gca, 'plot_settings' );
if ~isfield( linker, 'line_handle' )     
    residue1 = getappdata( gca, linker.residue1 );
    residue2 = getappdata( gca, linker.residue2 );
    if ~isfield( residue1, 'plot_pos' ) return; end;
    if ~isfield( residue2, 'plot_pos' ) return; end;
    if strcmp(linker.type,'stack' ) 
        if ( norm( residue1.plot_pos - residue2.plot_pos ) < 1.5 * plot_settings.bp_spacing ) return; end;
    end
    if strcmp(linker.type,'arrow' ) 
        if ( norm( residue1.plot_pos - residue2.plot_pos ) < 1.5 * plot_settings.spacing ) return; end;
    end
end

linker = draw_default_linker( linker );
   
% linker starts at res1 and ends at res2
linker = set_linker_endpos( linker, linker.residue1, 'relpos1',  1 );
linker = set_linker_endpos( linker, linker.residue2, 'relpos2', -1 );

% figure out positions in figure frame, based on each residue's
% helix frame:
plot_pos1 = get_plot_pos( linker.residue1, linker.relpos1 );
plot_pos2 = get_plot_pos( linker.residue2, linker.relpos2 );
plot_pos = [plot_pos1; plot_pos2 ];


if isfield( linker, 'arrow' ) 
    % hide linkers connecting consecutive residues if they are close
    % (this is a choice; could also show linker without arrow)
    if ( size( plot_pos, 1 ) == 2 & ...
            norm( plot_pos(2,:) - plot_pos(1,:) ) < 1.5*plot_settings.spacing );
        visible = 'off'; 
    else 
        visible = 'on'; 
    end;
    if ( check_for_base_pair( linker.residue1, linker.residue2 ) ) visible = 'off'; end;
    set( linker.line_handle, 'visible', visible); 
    if isfield( linker, 'vtx' ); 
        vtx_visible = visible;
        if ( isfield( plot_settings, 'show_linker_controls' ) & ~plot_settings.show_linker_controls ) vtx_visible = 'off'; end;
        for i = 1:length( linker.vtx ), set( linker.vtx{i}, 'visible', vtx_visible ); end;
    end;
    residue1 = getappdata( gca, linker.residue1 );
    % color setting
    color = 'k';  %black is default
    if ( isfield( plot_settings, 'color_arrows' ) & plot_settings.color_arrows & isfield( residue1, 'rgb_color' ) ); color = residue1.rgb_color; end
    set( linker.line_handle, 'color',color);
    set( linker.arrow, 'edgecolor',color );
    set( linker.arrow, 'facecolor',color );
end;
if strcmp( linker.type, 'stack' )  % to guide the eye.
    if ( norm( plot_pos(end,:) - plot_pos(1,:) ) < 1.5 * plot_settings.bp_spacing ); visible = 'off'; else visible = 'on'; end;
    set( linker.line_handle, 'visible', visible);
end
    
% nudge beginning and end of linker away from residue.
plot_pos1(1,:)   = nudge_pos( plot_pos(1,:),   plot_pos(2,:),     plot_settings.bp_spacing );
plot_pos2(end,:) = nudge_pos( plot_pos(end,:), plot_pos(end-1,:), plot_settings.bp_spacing );
plot_pos(1,:)   = plot_pos1(1,:);
plot_pos(end,:) = plot_pos2(end,:);
linker.plot_pos = plot_pos;

% replot the line
set( linker.line_handle, 'xdata', plot_pos(:,1), 'ydata', plot_pos(:,2) );

% place symbols on central segment
pos1 = plot_pos1( end, : );
pos2 = plot_pos2(   1, : );
ctr = (pos1+pos2)/2; % center of connecting line
v = pos2 - pos1; v = v/norm(v); % unit vector from res1 to res2
if isfield(linker,'arrow'); update_arrow( linker.arrow, ctr, v, visible, plot_settings.spacing ); end;
if isfield(linker,'symbol');  update_symbol( linker.symbol, ctr, v, 2, plot_settings.bp_spacing );  end
if isfield(linker,'symbol1'); update_symbol( linker.symbol1, ctr - (1.3*plot_settings.bp_spacing/10)*v, v, 1, plot_settings.bp_spacing );  end;
if isfield(linker,'symbol2'); update_symbol( linker.symbol2, ctr + (1.3*plot_settings.bp_spacing/10)*v, v, 2, plot_settings.bp_spacing );  end

% if there are vertex symbols at end points, re-draw them.
if isfield( linker, 'vtx' )
    set( linker.vtx{1}  , 'XData', plot_pos(1,1)  , 'YData', plot_pos(1,2) );
    set( linker.vtx{end}, 'XData', plot_pos(end,1), 'YData', plot_pos(end,2) );
end

setappdata( gca, linker.linker_tag, linker );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function linker = draw_default_linker( linker );
% already drawn?
if isfield( linker, 'line_handle' ); return; end;
switch linker.type
    case 'stem_pair'
        residue1 = getappdata( gca, linker.residue1 );
        residue2 = getappdata( gca, linker.residue2 );
        bp = [residue1.nucleotide,residue2.nucleotide];
        linker.line_handle = plot( [0,0],[0,0],'k','linewidth',0.5,'clipping','off' ); % dummy for now -- will get redrawn later.
        switch bp
            case {'AU','UA','GC','CG' } % could also show double lines for G-C. Not my preference.
                set( linker.line_handle, 'visible', 'on' );
            case {'GU','UG'}
                plot_settings = getappdata( gca, 'plot_settings' );
                linker.symbol = create_LW_symbol( 'W', 'C', plot_settings.bp_spacing );
                set( linker.line_handle, 'visible', 'off' ); % convention for G*U in stems is to not show line.
        end
        setappdata( gca, linker.linker_tag, linker );
    case 'noncanonical_pair'
        plot_settings = getappdata( gca, 'plot_settings' );
        linker.line_handle = plot( [0,0],[0,0],'k','linewidth',0.5,'clipping','off'); % dummy for now -- will get redrawn later.
        if ( linker.edge1 == linker.edge2 )
            linker.symbol = create_LW_symbol( linker.edge1, linker.LW_orientation, plot_settings.bp_spacing );
        else
            linker.symbol1 = create_LW_symbol( linker.edge1, linker.LW_orientation, plot_settings.bp_spacing );
            linker.symbol2 = create_LW_symbol( linker.edge2, linker.LW_orientation, plot_settings.bp_spacing );
        end
        setappdata( gca, linker.linker_tag, linker );
    case 'arrow'
        linker.line_handle = plot( [0,0],[0,0],'k','linewidth',1.2,'clipping','off' ); % dummy for now -- will get redrawn later.
        linker.arrow = patch( [0,0,0],[0,0,0],'k' );
        setappdata( gca, linker.linker_tag, linker );
    case 'stack'
        linker.line_handle = plot( [0,0],[0,0],'color',[0.8 0.8 0.8],'linestyle',':','linewidth',1.5,'clipping','off' ); % dummy for now -- will get redrawn later.
        %linker.line_handle = plot( [0,0],[0,0],'color',[0.8 0.8 0.8],'linestyle','-','linewidth',5 ); % dummy for now -- will get redrawn later.
        setappdata( gca, linker.linker_tag, linker );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_symbol( h, pos, v, which_symbol, bp_spacing );
vertices = get(h,'Vertices');
numv = size(vertices,1);
rot = atan2( v(2), v(1) ); % rotate so that symbol 'aligns' with line.
if which_symbol == 1; rot = rot + pi; end;
switch numv
    case 3 % triangle
        t = rot+[0 2*pi/3 2*pi*2/3];
        r = bp_spacing/10 * 1.5*sqrt(3)/2;
    case 4 % square
        t = rot+[0 pi/2 pi 3*pi/2]+pi/4;
        r = bp_spacing/10 * sqrt(2);
    otherwise % circle
        t = rot+linspace(0, 2*pi);
        r = bp_spacing/10;
end
vertices = [r*cos(t); r*sin(t) ]' + repmat( pos, size(vertices,1), 1 );
assert( numv == size( vertices, 1 ) );
set( h, 'xdata', vertices(:,1) );
set( h, 'ydata', vertices(:,2) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h_new = create_linker_vertex( pos, linker_tag );
plot_settings = getappdata( gca, 'plot_settings' );
visible = 'on';
if ( isfield(plot_settings,'show_linker_controls') & ~plot_settings.show_linker_controls ) visible = 'off'; end; % user-override
h_new = plot( pos(1),pos(2),'o',...
    'markersize',plot_settings.spacing*1.5,...
    'color',[0.5 0.5 1],...
    'markerfacecolor',[0.5 0.5 1],...
    'visible',visible,'clipping','off');
setappdata( h_new, 'linker_tag', linker_tag );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h_new = create_draggable_linker_vertex( pos, linker_tag )
h_new = create_linker_vertex( pos, linker_tag );
draggable( h_new, 'n',[-inf inf -inf inf], @move_snapgrid, 'endfcn', @redraw_linker_vtx );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = create_endpoint_linker_vertex( pos, linker_tag )
h = create_linker_vertex( pos, linker_tag );
plot_settings = getappdata( gca, 'plot_settings' );
set( h, 'markerfacecolor','w','markersize',plot_settings.spacing);
draggable( h,  'n',[-inf inf -inf inf], @move_snapgrid, 'endfcn', @new_linker_vtx );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_linker_vtx( h )
delete_crosshair();
pos = [get(h,'XData' ), get(h,'YData' )];
linker_tag = getappdata( h, 'linker_tag' );
linker = getappdata( gca, linker_tag );

% create new draggable symbol
h_new = create_draggable_linker_vertex( pos, linker_tag );

% install this new vertex in linker vertices.
plot_settings = getappdata( gca, 'plot_settings' );
if ( h == linker.vtx{1} )
    relpos = get_relpos_based_on_restag( pos, linker.residue1 );
    if ( norm( linker.relpos1(1,:) - relpos ) >= plot_settings.bp_spacing/4 )
        linker.relpos1 = [ linker.relpos1(1,:); relpos; linker.relpos1(2:end,:)];
        linker.vtx = [linker.vtx(1), {h_new}, linker.vtx(2:end)];
    else
        delete( h_new );
    end
else
    assert( h == linker.vtx{end} );
    relpos = get_relpos_based_on_restag( pos, linker.residue2 );
    if ( norm( linker.relpos2(end,:) - relpos ) >= plot_settings.bp_spacing/4 )
        linker.relpos2 = [ linker.relpos2(1:end-1,:); relpos; linker.relpos2(end,:)]
        linker.vtx = [linker.vtx(1:end-1), {h_new}, linker.vtx(end)];
    else
        delete( h_new );
    end
end

linker = draw_linker( linker );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function redraw_linker_vtx( h )
% can also delete if vtx comes close to endpoint
delete_crosshair();
pos = [get(h,'XData' ), get(h,'YData' )];
linker_tag = getappdata( h, 'linker_tag' );
linker = getappdata( gca, linker_tag );

plot_settings = getappdata( gca, 'plot_settings' );
n1 = size( linker.relpos1, 1 );
for n = 1:length( linker.vtx )
    if ( linker.vtx{n} == h )
        if n <= n1
            linker.relpos1( n, : ) = get_relpos_based_on_restag( pos, linker.residue1 );
            if ( norm( linker.relpos1(n,:) - linker.relpos1(1,:) ) < plot_settings.bp_spacing/4 ) 
                delete( h );
                linker.relpos1 = linker.relpos1( [1:n-1, n+1:end], : );
                linker.vtx = linker.vtx( [1:n-1, n+1:end] );
            end
            break;
        else
            n_off = n - n1;
            linker.relpos2( n_off, : ) = get_relpos_based_on_restag( pos, linker.residue2 );
            if ( norm( linker.relpos2( n_off, :) - linker.relpos2(end,:) ) < plot_settings.bp_spacing/4 )
                delete( h );
                linker.relpos2 = linker.relpos2( [1:n_off-1, n_off+1:end], : );
                linker.vtx = linker.vtx( [1:n-1, n+1:end] );
            end
            break;
        end
    end
end

% above loop should find a vertex match and break!
assert( n <= length( linker.vtx ) );
assert( size( [linker.relpos1;linker.relpos2], 1 ) == length(linker.vtx) );

draw_linker( linker );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function base_paired = check_for_base_pair( res_tag1, res_tag2 )
residue1 = getappdata( gca, res_tag1 );
base_paired = false;
for i = 1:length( residue1.linkers )
    linker_tag = residue1.linkers{i};
    linker = getappdata( gca, linker_tag );
    if strcmp( linker.type,'noncanonical_pair' ) | strcmp( linker.type,'stem_pair' )
        if ( strcmp( linker.residue1 , res_tag1 ) && strcmp( linker.residue2, res_tag2 ) ) 
            base_paired = true; return;
        end
        if ( strcmp( linker.residue1 , res_tag2 ) && strcmp( linker.residue2, res_tag1 ) ) 
            base_paired = true; return;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ticks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function residue = draw_tick( residue, bp_spacing, R )
if isfield( residue, 'tickrot' )
    if  isnan(residue.tickrot) residue = set_default_tickrot( residue ); end;
    theta = residue.tickrot;
    v = [cos(theta*pi/180), sin(theta*pi/180)]*R;
    tickpos1 = residue.plot_pos + v*bp_spacing/3; 
    tickpos2 = residue.plot_pos + v*bp_spacing*2/3;
    %if isfield( residue, 'tick_handle' )
    set( residue.tick_handle, 'xdata', [tickpos1(1) tickpos2(1)] );
    set( residue.tick_handle, 'ydata', [tickpos1(2) tickpos2(2)] );
    labelpos = residue.plot_pos + v*bp_spacing*2/3;
    set( residue.tick_label, 'position', labelpos );
    set_text_alignment( residue.tick_label, v );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function residue = set_default_tickrot( residue )
if ( sign( residue.relpos(2) ) > 0 ) 
    residue.tickrot = 90;
else
    residue.tickrot = 270;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function move_tick(h)
% snap to grid during movement.
pos = get(h,'Position');
pos = pos(1:2); % text
residue = getappdata( gca, getappdata(h,'res_tag') );
v = pos - residue.plot_pos;
theta = atan2( v(2), v(1) );
theta = round(theta*180/pi/45)*45;
v = [cos(theta*pi/180),sin(theta*pi/180)];
plot_settings = getappdata(gca,'plot_settings');
labelpos = residue.plot_pos + v*plot_settings.bp_spacing*2/3;
set(h,'Position',labelpos);
set_text_alignment( h, v );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function redraw_tick_res_and_helix(h)

pos = get(h,'Position');
pos = pos(1:2); % text

% position relative to residue will define tickrot
res_tag =  getappdata(h,'res_tag');
residue = getappdata( gca,res_tag );
v = pos - residue.plot_pos;
helix = getappdata( gca, residue.helix_tag );

% need to get into 'helix frame';
R = get_helix_rotation_matrix( helix );
v = v*R'; 
tickrot = mod( round(atan2(v(2),v(1))*180/pi/45)*45, 360 );
residue.tickrot = tickrot;
setappdata( gca, res_tag, residue );

% shortcut to redraw everything.
redraw_res_and_helix( residue.handle );


