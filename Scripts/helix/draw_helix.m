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
helix = make_helix_label( helix, plot_settings, R );

% Selections (if they exist)
selections = {};
for i = 1:length( helix.associated_residues )
    res_tag = helix.associated_residues{i};
    residue = getappdata( gca, res_tag );
    if isfield( residue, 'associated_selections' ) & length( residue.associated_selections ) > 0
        selections = [ selections, residue.associated_selections ];
    end    
end
selections = unique( selections );
draw_selections( selections );

% handles for helix editing
% rectangle for dragging.
minpos = min( [all_pos1; all_pos2 ] );
maxpos = max( [all_pos1; all_pos2 ] );
helix = create_default_rectangle( helix, 'helix_tag', helix.helix_tag, @redraw_helix );
set_rectangle_coords( helix, minpos, maxpos, spacing );

% for helix: clickable line of reflection
if ~isfield( helix, 'reflect_line1' )
    h = plot( [0 0], [0 0], 'color',[0.5 0.5 1],'clipping','off' );
    setappdata( h, 'helix_tag', helix.helix_tag);
    set(h,'ButtonDownFcn',{@reflect_helix,h});
    helix.reflect_line1 = h;
end
line1 = helix_center + spacing*[-(N+0.25)/2, 0]*R;
line1x = helix_center + spacing*[-(N-0.75)/2, 0]*R;
set( helix.reflect_line1, 'Xdata', [line1(1) line1x(1)], 'Ydata', [line1(2) line1x(2)]);

if ~isfield( helix, 'reflect_line2' )
    h = plot( [0 0], [0 0], 'color',[0.5 0.5 1],'clipping','off' );
    setappdata( h, 'helix_tag', helix.helix_tag);
    set(h,'ButtonDownFcn',{@reflect_helix,h});
    helix.reflect_line2 = h;
end
line2 = helix_center + spacing*[ (N+0.25)/2, 0]*R;
line2x = helix_center + spacing*[ (N-0.75)/2, 0]*R;
set( helix.reflect_line2, 'Xdata', [line2(1) line2x(1)], 'Ydata', [line2(2) line2x(2)]);

% for helix: clickable center of rotation
if ~isfield( helix, 'click_center' )
    h = rectangle( 'Position',...
        [ 0 0 0 0 ], ...
        'curvature',[0.5 0.5],...
        'edgecolor',[0.5 0.5 1],...
        'facecolor',[0.5 0.5 1],'linewidth',1.5,'clipping','off' );
    setappdata( h,'helix_tag', helix.helix_tag);
    set(h,'ButtonDownFcn',{@rotate_helix,h});
    helix.click_center = h;
end
set( helix.click_center, 'Position', [helix_center(1)-0.15*spacing helix_center(2)-0.15*spacing,...
    0.3*spacing 0.3*spacing]);

% make ticklabels draggable
for i = 1:length( helix.associated_residues )
    res_tag = helix.associated_residues{i};
    residue = getappdata( gca, res_tag );
    if isfield( residue, 'tick_label' ) & isvalid( residue.tick_label )
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
        if ~isfield( linker, 'vtx' ) | size(linker.plot_pos,1) ~= length( linker.vtx )
            linker = create_linker_with_draggable_vtx( linker );
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
% Helix/Domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Residue 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = draw_residue( res_tag, helix_center, R, plot_settings );
residue = getappdata( gca, res_tag );
if isfield( residue, 'relpos' ) 
    pos = helix_center +  residue.relpos * R ;
    if ~isfield( residue, 'handle' ) | ~isvalid( residue.handle )
        residue.handle = text( ...
            0, 0,...
            residue.nucleotide,...
            'fontsize', plot_settings.fontsize, ...
            'fontname','helvetica','horizontalalign','center','verticalalign','middle',...
            'clipping','off');
        if isfield( plot_settings, 'boldface' )
            if plot_settings.boldface == 1; fontweight = 'bold'; else; fontweight = 'normal'; end;
            set( residue.handle, 'fontweight',fontweight );
        end
    end
    if ( plot_settings.fontsize ~= get( residue.handle, 'fontsize' ) ) set( residue.handle, 'fontsize', plot_settings.fontsize ); end;
    h = residue.handle;
    set( h, 'Position', pos );
    if ( length( residue.nucleotide ) > 1 ) set( h, 'fontsize', plot_settings.fontsize*4/5); end;
    setappdata( residue.handle, 'res_tag', res_tag );
    residue.res_tag = res_tag;
    residue.plot_pos = pos;
    if isfield( residue, 'rgb_color' ) set(h,'color',residue.rgb_color ); end;
    residue = draw_tick( residue, plot_settings.bp_spacing, plot_settings.fontsize, R );
    % quick linker cleanup
    if isfield( residue, 'linkers' );
        linker_tags = residue.linkers;
        for k = 1 : length( linker_tags );  ok_linker(k) = isappdata( gca, linker_tags{k} );     end
        residue.linkers = linker_tags( ok_linker );
    end
    setappdata( gca, res_tag, residue );
end


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
    d = residue.resnum-helix.resnum1(1);
    if abs(d) > 10; d = sign(d) * 10 * ( log( abs(d)/ 10) + 1 );  end;
    relpos = [ plot_settings.spacing*(d-(N-1)/2), -plot_settings.bp_spacing/2];
else
    assert( strand == 2 );    
    d = residue.resnum-helix.resnum2(1);
    if abs(d) > 10; d = sign(d) * 10 * ( log( abs(d)/ 10) + 1 );  end;
    relpos = [ plot_settings.spacing*(-d+(N-1)/2), +plot_settings.bp_spacing/2];  
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
function helix = make_helix_label( helix, plot_settings, R )
% make label
if ~isfield( helix, 'label' ) | ~isvalid( helix.label)
    h = text( 0,0, helix.name,...
        'fontsize', plot_settings.fontsize*1.5, 'fontname','helvetica','clipping','off');
    helix.label = h;
    % draggable helix label
    setappdata( helix.label, 'helix_tag', helix.helix_tag );
    draggable( helix.label, 'n',[-inf inf -inf inf], @move_helix_label, 'endfcn', @redraw_helix_label )
end
h = helix.label;
label_pos = helix.center + helix.label_relpos * R;
set( h, 'String', helix.name );
set( h, 'position', label_pos );
set( h, 'fontsize', plot_settings.fontsize*1.5 );
if isfield( helix, 'rgb_color' ) set( h, 'color', helix.rgb_color ); end;
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
% Ticks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function residue = draw_tick( residue, bp_spacing, fontsize, R )

if ( mod(residue.resnum,10) ~= 0 ); return; end;

if ~isfield( residue, 'tickrot' ) residue.tickrot = nan; end; % nan means set later based on how helix is rotated.

if ~isfield( residue, 'tick_handle' ) | ~isvalid( residue.tick_handle )
    residue.tick_handle = plot( [0,0],[0,0],'k','linewidth',0.5,'clipping','off'); % dummy for now -- will get redrawn later.
    setappdata( gca, residue.res_tag, residue );
end

if ~isfield( residue, 'tick_label' ) | ~isvalid( residue.tick_label )
    residue.tick_label = text( 0, 0, num2str(residue.resnum), 'fontsize', fontsize,...
        'horizontalalign','center','verticalalign','middle','clipping','off' );
    setappdata( gca, residue.res_tag, residue );
end

if isfield( residue, 'tickrot' ) 
    if  isnan(residue.tickrot) residue = set_default_tickrot( residue ); end;
    theta = residue.tickrot;
    v = [cos(theta*pi/180), sin(theta*pi/180)]*R;
    tickpos1 = residue.plot_pos + v*bp_spacing/3; 
    tickpos2 = residue.plot_pos + v*bp_spacing*2/3;
    set( residue.tick_handle, 'xdata', [tickpos1(1) tickpos2(1)] );
    set( residue.tick_handle, 'ydata', [tickpos1(2) tickpos2(2)] );
    labelpos = residue.plot_pos + v*bp_spacing*2/3;
    set( residue.tick_label, 'position', labelpos );
    plot_settings = getappdata( gca, 'plot_settings' );
    if ( get(residue.tick_label, 'fontsize') ~= plot_settings.fontsize ) 
        set( residue.tick_label, 'fontsize', plot_settings.fontsize );  
    end;
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

