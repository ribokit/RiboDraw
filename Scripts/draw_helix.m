function helix = draw_helix( helix )

fontsize = 8;
spacing = 3;
bp_spacing = 6;

helix_center = helix.center;
theta = helix.rotation;
R = [cos(theta*pi/180) -sin(theta*pi/180);sin(theta*pi/180) cos(theta*pi/180)];
N = length( helix.resnum1 );
init = false;

helix.l = make_label( helix, bp_spacing, fontsize, theta, R );
    
for k = 1:N
    pos1 = [helix_center(1) helix_center(2)] + [ spacing*((k-1)-(N-1)/2), -bp_spacing/2]*R;
    pos2 = [helix_center(1) helix_center(2)] + [ spacing*((k-1)-(N-1)/2), +bp_spacing/2]*R;
    helix.s1(k) = text( ...
        pos1(1), pos1(2),...
        upper(helix.strand1(k)),...
        'fontsize', fontsize, 'fontname','helvetica','horizontalalign','center','verticalalign','middle');
    helix.s2(k) = text( ...
        pos2(1), pos2(2), ...
        upper(helix.strand2(k)),...
        'fontsize', fontsize, 'fontname','helvetica','horizontalalign','center','verticalalign','middle');
    
    bp = [helix.strand1(k),helix.strand2(k)];
    switch bp
        case {'au','ua','gc','cg' }
            bp_pos1 = pos1 + [0 bp_spacing/3]*R;
            bp_pos2 = pos2 + [0 -bp_spacing/3]*R;
            helix.bp(k) = plot( [bp_pos1(1),bp_pos2(1)],[bp_pos1(2),bp_pos2(2)],'k-','linewidth',1.5); hold on;
        case {'gu','ug'}
            bp_pos = (pos1+pos2)/2;
            helix.bp(k) = rectangle( 'position',...
                [bp_pos(1)-bp_spacing/10, bp_pos(2)-bp_spacing/10,...
                bp_spacing*2/10, bp_spacing*2/10],...
                'edgecolor','k','facecolor','k','curvature',[1 1]);
    end
    
    % draw little arrows into and out of each strand
    DRAW_LITTLE_ARROWS = 0;
    if DRAW_LITTLE_ARROWS
        if ( k == 1 )
            helix.a_in1 = arrow( pos1-[spacing,0]*R, pos1-0.5*[spacing,0]*R,'length',5,...
                'edgecolor',[0.5 0.5 0.5],'facecolor',[0.5 0.5 0.5] );
            helix.a_out2 = arrow( pos2-0.5*[spacing,0]*R,pos2-[spacing,0]*R,'length',5,...
                'edgecolor',[0.5 0.5 0.5],'facecolor',[0.5 0.5 0.5] );
        elseif ( k == N )
            helix.a_out1 = arrow( pos1+0.5*[spacing,0]*R, pos1+[spacing,0]*R,'length',5,...
                'edgecolor',[0.5 0.5 0.5],'facecolor',[0.5 0.5 0.5] );
            helix.a_in2 = arrow( pos2+[spacing,0]*R,pos2+0.5*[spacing,0]*R,'length',5,...
                'edgecolor',[0.5 0.5 0.5],'facecolor',[0.5 0.5 0.5] );
        end
    end
    all_pos1(k,:) = pos1;
    all_pos2(k,:) = pos2;
end
minpos = min( [all_pos1; all_pos2 ] );
maxpos = max( [all_pos1; all_pos2 ] );

helix_tag = sprintf('Helix_%d%d',...
    helix.chain1(1),...
    helix.resnum1(1));% this better be a unique identifier

% handles for editing
% rectangle for dragging.
h = rectangle( 'Position',...
    [minpos(1) minpos(2) maxpos(1)-minpos(1) maxpos(2)-minpos(2) ]+...
    [-0.5 -0.5 1 1]*spacing,...
    'edgecolor',[0.5 0.5 1]);
setappdata(h,'helix_tag',helix_tag); 
draggable(h,'endfcn',@redraw_helix);
helix.helix_rectangle = h;

% clickable center of rotation
h = rectangle( 'Position',...
    [helix_center(1)-0.1*spacing helix_center(2)-0.1*spacing,...
    0.2*spacing 0.2*spacing], 'edgecolor',[0.5 0.5 1],'linewidth',1.5 );
setappdata( h, 'helix_tag', helix_tag);
set(h,'ButtonDownFcn',{@rotate_helix,h});
helix.clickcenter = h;

% 'global data' (stored in figure)
setappdata( gca, helix_tag, helix );

end


function h = make_label( helix, bp_spacing, fontsize, theta, R )
% make label
label_pos = helix.center + bp_spacing*[0 1]*R;
%if ~exist( 'firstdraw', 'var' ) firstdraw = 0; end;
h = text( label_pos(1), label_pos(2), helix.name,...
    'fontsize', fontsize*1.5, 'fontname','helvetica');
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


