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

helix.l = make_label( helix, plot_settings, theta, helix.parity, R );

spacing = plot_settings.spacing;
bp_spacing = plot_settings.bp_spacing;
helix_res_tags = {};
for k = 1:N
    % kind of clunky, and repeated code.
    % first partner of base pair -- will draw below.
    res_tag = sprintf( 'Residue_%s%d', helix.chain1(k), helix.resnum1(k) );
    residue1 = getappdata( gca, res_tag );
    residue1.relpos = [ spacing*((k-1)-(N-1)/2), -bp_spacing/2];
    pos1 = helix.center + residue1.relpos*R;
    setappdata( gca, res_tag, residue1);
    helix_res_tags = [helix_res_tags, res_tag ];

    % second partner of base pair -- will draw below.
    res_tag = sprintf( 'Residue_%s%d', helix.chain2(N-k+1), helix.resnum2(N-k+1) );
    residue2 = getappdata( gca, res_tag ); 
    residue2.relpos = [ spacing*((k-1)-(N-1)/2), +bp_spacing/2];
    pos2 = helix.center + residue2.relpos*R;
    setappdata( gca, res_tag, residue2);
    helix_res_tags = [helix_res_tags, res_tag ];
    
    % should probably make the following 'linkers' -- can slave them to
    % residue positions above.
    bp = [residue1.nucleotide,residue2.nucleotide];
    switch bp
        case {'AU','UA','GC','CG' }
            bp_pos1 = pos1 + [0 bp_spacing/3]*R;
            bp_pos2 = pos2 + [0 -bp_spacing/3]*R;
            helix.bp(k) = plot( [bp_pos1(1),bp_pos2(1)],[bp_pos1(2),bp_pos2(2)],'k-','linewidth',1.5); hold on;
        case {'GU','UG'}
            bp_pos = (pos1+pos2)/2;
            helix.bp(k) = rectangle( 'position',...
                [bp_pos(1)-bp_spacing/10, bp_pos(2)-bp_spacing/10,...
                bp_spacing*2/10, bp_spacing*2/10],...
                'edgecolor','k','facecolor','k','curvature',[1 1]);
    end
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
% in the future, these could include base pairs (incl. non-canonicals)/
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
        set( linker.line_handle, 'visible', visible);
        % displace line a bit to not overlap with text
        v = pos2 - pos1; v = v/norm(v);
        pos1d = pos1 +  (bp_spacing/3)*v;
        pos2d = pos2 -  (bp_spacing/3)*v;
        set( linker.line_handle, 'xdata', [pos1d(1) pos2d(1)] );
        set( linker.line_handle, 'ydata', [pos1d(2) pos2d(2)] );
        ctr = (pos1+pos2)/2;
        % draw a triangle too
        if isfield(linker,'arrow')
            x = v * [0 1; -1 0]; % cross direction
            set( linker.arrow, 'visible', visible);
            a1 = ctr - spacing/2*v-spacing/5*x;
            a2 = ctr - spacing/2*v+spacing/5*x;
            a3 = ctr + spacing/2*v;
            set( linker.arrow, 'xdata', ...
                [a1(1) a2(1) a3(1)] );
            set( linker.arrow, 'ydata', ...
                [a1(2) a2(2) a3(2)] );
        end
        if isfield(linker,'symbol')
            update_symbol( linker.symbol, ctr, v, 2, bp_spacing );
        end
        if isfield(linker,'symbol1')
            update_symbol( linker.symbol1, ctr -  (1.3*bp_spacing/10)*v, v, 1, bp_spacing );
        end
        if isfield(linker,'symbol2')
            update_symbol( linker.symbol2, ctr + (1.3*bp_spacing/10)*v, v, 2, bp_spacing );
        end
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
draggable(h,'endfcn',@redraw_helix);
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
setappdata( h, 'helix_tag', helix.helix_tag);
set(h,'ButtonDownFcn',{@rotate_helix,h});
helix.click_center = h;

% make single-stranded residues draggable...
for i = 1:length( not_helix_res_tags )
    res_tag = not_helix_res_tags{i};
    residue = getappdata( gca, res_tag );
    h = rectangle( 'position', [residue.plot_pos(1)-spacing/2, residue.plot_pos(2)-spacing/2, spacing, spacing],...
        'edgecolor',[0.5 0.5 1],'clipping','off' );
    setappdata(h, 'res_tag', res_tag );
    draggable(h,'endfcn',@redraw_res_and_helix);
    residue.residue_rectangle = h;
    setappdata( gca, res_tag, residue );
end

%%%%%%%%%%%%%%%%%%%%%
% DO THIS AT THE END
%%%%%%%%%%%%%%%%%%%%%
% 'global data' (stored in figure)
setappdata( gca, helix.helix_tag, helix );

end

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
    residue.handle = h;
    residue.plot_pos = pos;
    setappdata( gca, restag, residue )
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = make_label( helix, plot_settings, theta, parity, R )
% make label
label_pos = helix.center + plot_settings.bp_spacing*[0 1]*R;
%if ~exist( 'firstdraw', 'var' ) firstdraw = 0; end;
h = text( label_pos(1), label_pos(2), helix.name,...
    'fontsize', plot_settings.fontsize*1.5, 'fontname','helvetica');
if ( parity < 0 ) theta = mod( theta + 180 , 360 ) ; end;
switch theta
    case 0
        set( h,'horizontalalign','center','verticalalign','bottom');
    case 90
        set( h,'horizontalalign','left','verticalalign','middle');
    case 180
        set( h,'horizontalalign','center','verticalalign','top');
    case 270
        set( h,'horizontalalign','right','verticalalign','middle'); end;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function relpos = set_default_relpos( residue, helix, plot_settings )
% need to find which helix strand to append to, and then go out a bit.
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
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_symbol( h, pos, v, which_symbol, bp_spacing );
vertices = get(h,'Vertices');
numv = size(vertices,1);
rot = atan2( v(2), v(1) ); % rotate so that symbol 'aligns' with line.
if which_symbol == 1; rot = rot + pi; end;
switch numv
    case 3
        t = rot+[0 2*pi/3 2*pi*2/3];
        r = bp_spacing/10 * 1.5*sqrt(3)/2;
    case 4
        t = rot+[0 pi/2 pi 3*pi/2]+pi/4;
        r = bp_spacing/10 * sqrt(2);
    otherwise
        t = rot+linspace(0, 2*pi);
        r = bp_spacing/10;
end
vertices = [r*cos(t); r*sin(t) ]' + repmat( pos, size(vertices,1), 1 );
set( h, 'Vertices', vertices );
end


