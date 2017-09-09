function helix = draw_helix( helix )
% helix = draw_helix( helix )
% (C) R. Das, Stanford University, 2017

plot_settings = getappdata( gca, 'plot_settings' );

helix_center = helix.center;
theta = helix.rotation;
R = [cos(theta*pi/180) -sin(theta*pi/180);sin(theta*pi/180) cos(theta*pi/180)];
R = [1 0; 0 helix.parity] * R;
N = length( helix.resnum1 );
init = false;

if ~isfield( helix, 'label_relpos' ) helix.label_relpos = plot_settings.bp_spacing *[0 1]; end;
helix.l = make_label( helix, plot_settings, R );

spacing = plot_settings.spacing;
bp_spacing = plot_settings.bp_spacing;
helix_res_tags = {};
for k = 1:N
    % kind of clunky, and repeated code.
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
for i = 1:length( helix.associated_residues )
    res_tag = helix.associated_residues{i};
    residue = getappdata( gca, res_tag );
    linkers = residue.linkers;
    for k = 1 : length( linkers )
        linker = linkers{k};
         residue1 = getappdata( gca, linker.residue1 );
        residue2 = getappdata( gca, linker.residue2 );
        if ~isfield( residue1, 'plot_pos' ); continue; end;
        if ~isfield( residue2, 'plot_pos' ); continue; end;
        pos1 = residue1.plot_pos;
        pos2 = residue2.plot_pos;
        if ( norm( pos1 - pos2 ) < 1.5*plot_settings.spacing ) visible = 'off'; else; visible = 'on'; end;
        if strcmp( linker.type, 'arrow' ) set( linker.line_handle, 'visible', visible); end;
        ctr = (pos1+pos2)/2; % center of connecting line
        v = pos2 - pos1; v = v/norm(v); % unit vector from res1 to res2
        if isfield( linker, 'line_handle' ); update_line( linker.line_handle, pos1, pos2, v, visible, bp_spacing ); end;
        if isfield(linker,'arrow'); update_arrow( linker.arrow, ctr, v, visible, spacing ); end;
        if isfield(linker,'symbol');  update_symbol( linker.symbol, ctr, v, 2, bp_spacing );  end
        if isfield(linker,'symbol1'); update_symbol( linker.symbol1, ctr -  (1.3*bp_spacing/10)*v, v, 1, bp_spacing );  end;
        if isfield(linker,'symbol2'); update_symbol( linker.symbol2, ctr + (1.3*bp_spacing/10)*v, v, 2, bp_spacing );  end
    end
end

% handles for helix editing
% rectangle for dragging.
minpos = min( [all_pos1; all_pos2 ] );
maxpos = max( [all_pos1; all_pos2 ] );
h = rectangle( 'Position',...
    [minpos(1) minpos(2) maxpos(1)-minpos(1) maxpos(2)-minpos(2) ]+...
    [-0.5 -0.5 1 1]*spacing,...
    'edgecolor',[0.5 0.5 1],'clipping','off');
setappdata(h,'helix_tag',helix.helix_tag); 
draggable(h,'n',[-inf inf -inf inf],@move_residue,'endfcn',@redraw_helix);
helix.helix_rectangle = h;

% clickable line of reflection
line1 = helix_center + spacing*[-(N+1)/2, 0]*R;
line2 = helix_center + spacing*[ (N+1)/2, 0]*R;
h = plot( [line1(1),line2(1)], [line1(2), line2(2)], 'color',[0.5 0.5 1],'clipping','off' );
setappdata( h, 'helix_tag', helix.helix_tag);
set(h,'ButtonDownFcn',{@reflect_helix,h});
helix.reflect_line = h;

% clickable center of rotation
h = rectangle( 'Position',...
    [helix_center(1)-0.1*spacing helix_center(2)-0.1*spacing,...
    0.2*spacing 0.2*spacing], 'edgecolor',[0.5 0.5 1],'facecolor',[0.5 0.5 1],'linewidth',1.5,'clipping','off' );
setappdata( h,'helix_tag', helix.helix_tag);
set(h,'ButtonDownFcn',{@rotate_helix,h});
helix.click_center = h;

% make single-stranded residues draggable...
for i = 1:length( not_helix_res_tags )
    res_tag = not_helix_res_tags{i};
    residue = getappdata( gca, res_tag );
    %     h = rectangle( 'position', [residue.plot_pos(1)-spacing/2, residue.plot_pos(2)-spacing/2, spacing, spacing],...
    %         'edgecolor',[0.5 0.5 1],'clipping','off' );
    %     setappdata(h, 'res_tag', res_tag );
    %     draggable(h,'n',[-inf inf -inf inf],@move_residue, 'endfcn',@redraw_res_and_helix);
    %     residue.residue_rectangle = h;
    %  setappdata( gca, res_tag, residue );
    draggable( residue.handle,@move_residue, 'endfcn', @redraw_res_and_helix )
    setappdata(residue.handle, 'res_tag', res_tag );
end

% draggable helix label
setappdata( helix.l, 'helix_tag', helix.helix_tag );
draggable( helix.l, 'n',[-inf inf -inf inf], @move_helix_label, 'endfcn', @redraw_helix_label )

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
function h = draw_residue( restag, helix_center, R, plot_settings );
residue = getappdata( gca, restag );
if isfield( residue, 'relpos' )
    pos = helix_center +  residue.relpos * R ;
    h = text( ...
        pos(1), pos(2),...
        residue.nucleotide,...
        'fontsize', plot_settings.fontsize, ...
        'fontname','helvetica','horizontalalign','center','verticalalign','middle',...
        'clipping','off');
    if ( length( residue.nucleotide ) > 1 ) set( h, 'fontsize', plot_settings.fontsize*4/5); end;
    residue.handle = h;
    residue.plot_pos = pos;
    residue = draw_tick( residue, plot_settings.bp_spacing, R );
    setappdata( gca, restag, residue )
end

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
function h = make_label( helix, plot_settings, R )
% make label
label_pos = helix.center + helix.label_relpos * R;
h = text( label_pos(1), label_pos(2), helix.name,...
    'fontsize', plot_settings.fontsize*1.5, 'fontname','helvetica');
v = label_pos - helix.center;
set_text_alignment( h, v );
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function move_helix_label(h)
pos = get(h,'position'); 
helix_tag = getappdata( h, 'helix_tag' );
helix = getappdata( gca, helix_tag );
v = pos(1:2) - helix.center;
set_text_alignment( h, v );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function redraw_helix_label(h)

pos = get(h,'position'); 
helix_tag = getappdata( h, 'helix_tag' );
helix = getappdata( gca, helix_tag );

% need to figure out rel_pos back in the 'frame' of the helix.
% for that I need to figure out rotation matrix.
theta = helix.rotation;
R = [cos(theta*pi/180) -sin(theta*pi/180);sin(theta*pi/180) cos(theta*pi/180)];
R = [1 0; 0 helix.parity] * R;
helix.label_relpos = ( pos(1:2) - helix.center ) * R';

% snap to grid?
plot_settings = getappdata( gca, 'plot_settings' );
snap_spacing = plot_settings.bp_spacing/2;
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
function relpos = set_default_relpos( residue, helix, plot_settings )
% need to find which helix st;rand to append to, and then go out a bit.
dist1 = min( abs(helix.resnum1 - residue.resnum) );
if ( residue.chain ~= helix.chain1(1) ) dist1 = Inf * dist1; end;
dist2 = min( abs(helix.resnum2 - residue.resnum) );
if ( residue.chain ~= helix.chain2(1) ) dist2 = Inf * dist2; end;
[~,strand] = min( [min( dist1 ), min( dist2 )] );
N = length( helix.resnum1 );
if ( strand == 1 )   
    relpos = [ plot_settings.spacing*(+(residue.resnum-helix.resnum1(1))-(N-1)/2), -plot_settings.bp_spacing/2-plot_settings.spacing/4];
else
    assert( strand == 2 );    
    relpos = [ plot_settings.spacing*(-(residue.resnum-helix.resnum2(1))+(N-1)/2), +plot_settings.bp_spacing/2+plot_settings.spacing/4];  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pos = update_residue_pos( res_tag, relpos, center, R );
residue = getappdata( gca, res_tag );
residue.relpos = relpos;
pos = center + relpos*R;
setappdata( gca, res_tag, residue);


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
function update_line( h, pos1, pos2, v, visible, bp_spacing)
% displace line a bit to not overlap with text
pos1d = pos1 +  (bp_spacing/3)*v;
pos2d = pos2 -  (bp_spacing/3)*v;
set( h, 'xdata', [pos1d(1) pos2d(1)] );
set( h, 'ydata', [pos1d(2) pos2d(2)] );


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
function move_residue(h)
% don't really need this function, but allows
% snap to grid during movement.

% works for both text (residue) and rectangle (helix).
pos = get(h,'Position');
if length( pos ) == 4 % rectangle
    res_center = [pos(1)+pos(3)/2, pos(2)+pos(4)/2];
else
    res_center = pos(1:2); % text
end

% Computing the new position of the rectangle
plot_settings = getappdata(gca,'plot_settings');
grid_spacing = plot_settings.spacing/4;
new_position = round(res_center/grid_spacing)*grid_spacing;

% Updating the rectangle' XData and YData properties
delta = new_position - res_center;
if length( pos ) == 4 % rectangle
    pos = pos + [delta, 0, 0];
else
    pos = pos + [delta, 0]; % text
end

set(h,'Position',pos );



