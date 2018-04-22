function linker = draw_linker( linker, plot_settings )
% linker = draw_linker( linker )
% linker = draw_linker( linkers )
%
% Draw the linker (arrow, stem_pair, noncanonical_pair, tertiary contact)
%  including symbols.
%
% Input:
%  linker = Linker object (or tag string) to draw. Cell of multiple linkers is also OK.
%  plot_settings = [optional] plot settings (if not supplied, funciton will
%                       infer from current axes)
%
% Output:
%  linker = Linker object potentially with updated plot_pos or graphics handles
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'plot_settings','var' ) plot_settings = getappdata( gca, 'plot_settings' ); end
if iscell( linker )
    for i = 1:length( linker ); draw_linker( linker{i}, plot_settings ); end
    return;
end
if ischar( linker ) 
    if isappdata( gca, linker ) 
        linker = getappdata( gca, linker );
    else
        fprintf( 'Could not find %s\n', linker );
        return;
    end
end;

% the rendering in this function  ends up being rate limiting for
% draw_helix -- early return if we don't have to make anything
toggle_types    = {'stack','other_contact','noncanonical_pair','stem_pair','long_range_stem_pair','ligand','tertcontact_intradomain','tertcontact_interdomain' };
toggle_settings = {'show_stacks','show_other_contacts','show_noncanonical_pairs','show_stem_pairs','show_stem_pairs','show_ligand_linkers','show_tertiary_contacts','show_tertiary_contacts'};
for i = 1:length(toggle_types)
    if strcmp(linker.type,toggle_types{i}) && isfield( plot_settings, toggle_settings{i} ) && ~getfield(plot_settings,toggle_settings{i}) 
        linker = delete_linker( linker, 0 ); setappdata( gca, linker.linker_tag, linker ); return;
    end;
end
if ~isfield( linker, 'line_handle' ) && linker_is_too_short_for_display( linker, plot_settings ); linker = delete_linker( linker, 0 ); return; end;

% linker starts at res1 and ends at res2
linker = set_linker_endpos( linker, linker.residue1, 'relpos1',  1 );
linker = set_linker_endpos( linker, linker.residue2, 'relpos2', -1 );
% figure out positions in figure frame, based on each residue's
% helix frame:
plot_pos1 = get_plot_pos( linker.residue1, linker.relpos1 );
plot_pos2 = get_plot_pos( linker.residue2, linker.relpos2 );
plot_pos = [plot_pos1; plot_pos2 ];
end_pos1 = plot_pos1(1,:);
end_pos2 = plot_pos2(end,:);

if strcmp( linker.type, 'arrow' ) 
    % hide linkers connecting consecutive residues if they are close
    % (this is a choice; could also show linker without arrow)
    if ( size( plot_pos, 1 ) == 2 & ...
            norm( plot_pos(2,:) - plot_pos(1,:) ) < 1.5*plot_settings.spacing );
        visible = 'off'; 
    else 
        visible = 'on'; 
    end;
    if ( check_for_base_pair( linker.residue1, linker.residue2 ) ) visible = 'off'; end;
    if strcmp( visible, 'off' );
        linker = delete_linker( linker, 0 ); % delete linker handle!
        return;
    end;
    linker = draw_default_linker( linker );
    set( linker.line_handle, 'visible', visible); 
    if isfield( linker, 'vtx' ); 
        vtx_visible = visible;
        if ( isfield( plot_settings, 'show_linker_controls' ) & ~plot_settings.show_linker_controls ) vtx_visible = 'off'; end;
        for i = 1:length( linker.vtx ), if isvalid( linker.vtx{i} ); set( linker.vtx{i}, 'visible', vtx_visible ); end; end;
    end;
    residue1 = getappdata( gca, linker.residue1 );
    % color setting
    color = 'k';  %black is default
    if ( isfield( plot_settings, 'color_arrows' ) & plot_settings.color_arrows & isfield( residue1, 'rgb_color' ) ); color = residue1.rgb_color; end
    set( linker.line_handle, 'color',color);
    set( linker.arrow, 'edgecolor',color );
    set( linker.arrow, 'facecolor',color );
    arrow_linewidth = get_arrow_linewidth( plot_settings.fontsize );
    set( linker.line_handle, 'linewidth', arrow_linewidth );
elseif strcmp( linker.type, 'stack' )  % to guide the eye.
    if ( norm( plot_pos(end,:) - plot_pos(1,:) ) < 1.5 * plot_settings.bp_spacing ); visible = 'off'; else visible = 'on'; end;
    if strcmp( visible, 'off' ) 
        linker = delete_linker( linker, 0 ); % delete linker handle!
        return; 
    end;
    linker = draw_default_linker( linker );
    set( linker.line_handle, 'visible', visible);
else
    linker = draw_default_linker( linker );
end
    
% nudge beginning and end of linker away from residue.
nudge_spacing = plot_settings.bp_spacing;
if isfield( getappdata( gca, linker.residue1 ), 'ligand_partners' ); nudge_spacing = nudge_spacing * 2; end;
plot_pos1(1,:)   = nudge_pos( plot_pos(1,:),   plot_pos(2,:),     nudge_spacing );
plot_pos2(end,:) = nudge_pos( plot_pos(end,:), plot_pos(end-1,:), nudge_spacing );
plot_pos(1,:)   = plot_pos1(1,:);
plot_pos(end,:) = plot_pos2(end,:);
linker.plot_pos = plot_pos;

% replot the line
if ~isfield( linker, 'line_handle' ) ; return ; end
set( linker.line_handle, 'xdata', plot_pos(:,1), 'ydata', plot_pos(:,2) );

% draw (draggable) vertices if they don't exist yet.
if isfield( linker, 'plot_pos' ) 
    if isfield( linker, 'vtx' ) 
        linker_vtx_ok = 1;
        for i = 1:length( linker.vtx ); if ~isvalid( linker.vtx{i} ); linker_vtx_ok = 0; break; end; end;
        if size(linker.plot_pos,1) ~= length( linker.vtx ) linker_vtx_ok = 0; end;
        if ~linker_vtx_ok
            for i = 1:length( linker.vtx ); delete( linker.vtx{i} );  end;
            linker = rmfield( linker, 'vtx' );
        end
    end
    if ( ~isfield( linker, 'vtx' ) && ~strcmp( linker.type, 'stem_pair' ) && plot_settings.show_linker_controls  )                
        linker = create_linker_with_draggable_vtx( linker );
    end  
    if (isfield( linker, 'vtx' ) )
        for i = 1:size( linker.plot_pos, 1 )
            set( linker.vtx{i}, 'xdata', linker.plot_pos(i,1), 'ydata', linker.plot_pos(i,2) );
        end
    end
end

% place symbols on central segment
pos1 = plot_pos1( end, : );
pos2 = plot_pos2(   1, : );
ctr = (pos1+pos2)/2; % center of connecting line
v = pos2 - pos1; v = v/norm(v); % unit vector from res1 to res2
num_pos1 = size(plot_pos1,1);
if isfield(linker,'arrow'); update_arrow( linker.arrow, ctr, v, visible, plot_settings.spacing ); end;
if isfield(linker,'arrow') & isfield(plot_settings,'show_extra_arrows'); linker = update_extra_arrows( linker, plot_pos, num_pos1, plot_settings ); end;
if isfield(linker,'symbol');  update_symbol( linker.symbol, ctr, v, 2, plot_settings.bp_spacing );  end
if isfield(linker,'symbol1'); update_symbol( linker.symbol1, ctr - (1.3*plot_settings.bp_spacing/10)*v, v, 1, plot_settings.bp_spacing );  end;
if isfield(linker,'symbol2'); update_symbol( linker.symbol2, ctr + (1.3*plot_settings.bp_spacing/10)*v, v, 2, plot_settings.bp_spacing );  end
if isfield( linker, 'node1' ); update_symbol( linker.node1, end_pos1,v,1,plot_settings.bp_spacing*2.5 ); end; 
if isfield( linker, 'node2' ); update_symbol( linker.node2, end_pos2,v,1,plot_settings.bp_spacing*2.5 ); end; 
if isfield( linker, 'tertiary_contact' ); linker = update_tertiary_contact( linker, plot_pos, plot_settings ); end;
if any(strcmp(linker.type, {'noncanonical_pair'} )) check_interdomain( linker, plot_settings ); end;
if strcmp( linker.type, 'ligand' ) update_ligand_linker_visibility( linker, plot_settings ); end;

% if there are vertex symbols at end points, re-draw them.
if isfield( linker, 'vtx' )
    set( linker.vtx{1}  , 'XData', plot_pos(1,1)  , 'YData', plot_pos(1,2) );
    set( linker.vtx{end}, 'XData', plot_pos(end,1), 'YData', plot_pos(end,2) );
end

setappdata( gca, linker.linker_tag, linker );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function linker = draw_default_linker( linker );
% already drawn?
if isfield( linker, 'line_handle' ) & isvalid( linker.line_handle ); return; end;
plot_settings = getappdata( gca, 'plot_settings' );
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
    case { 'noncanonical_pair', 'long_range_stem_pair' }
        linker.line_handle = plot( [0,0],[0,0],'k','linewidth',0.5,'clipping','off'); % dummy for now -- will get redrawn later.
        if ( linker.edge1 == linker.edge2 )
            linker.symbol = create_LW_symbol( linker.edge1, linker.LW_orientation, plot_settings.bp_spacing );
        else
            linker.symbol1 = create_LW_symbol( linker.edge1, linker.LW_orientation, plot_settings.bp_spacing );
            linker.symbol2 = create_LW_symbol( linker.edge2, linker.LW_orientation, plot_settings.bp_spacing );
        end
        setappdata( gca, linker.linker_tag, linker );
    case 'arrow'
        linker.line_handle = plot( [0,0],[0,0],'k','linewidth',1.0,'clipping','off' ); % dummy for now -- will get redrawn later.
        linker.arrow = patch( [0,0,0],[0,0,0],'k','clipping','off' );
        set( linker.line_handle, 'linewidth', get_arrow_linewidth( plot_settings.fontsize ) ); 
        setappdata( gca, linker.linker_tag, linker );
    case 'stack'
        linker.line_handle = plot( [0,0],[0,0],'color',[0.8 0.8 0.8],'linestyle',':','linewidth',1.5,'clipping','off' ); % dummy for now -- will get redrawn later.
        setappdata( gca, linker.linker_tag, linker );
    case 'other_contact'
        linker.line_handle = plot( [0,0],[0,0],'color',[0.5 0.5 1],'linestyle',':','linewidth',5,'clipping','off' ); % dummy for now -- will get redrawn later.
        setappdata( gca, linker.linker_tag, linker );
    case 'ligand'
        linker.line_handle = plot( [0,0],[0,0],'color',[0.8 0.8 0.8],'linestyle','-','linewidth',1.5,'clipping','off' ); % dummy for now -- will get redrawn later.
        setappdata( gca, linker.linker_tag, linker );
        send_to_back( linker.line_handle );
    case {'tertcontact_interdomain','tertiary_contact_interdomain'}
        linker.type = 'tertcontact_interdomain';
        linker.line_handle = plot( [0,0],[0,0],'color',[0.8 0.8 0.8],'linestyle','-','linewidth',0.5,'clipping','off' ); % dummy for now -- will get redrawn later.
        linker.node1 = create_undercircle( plot_settings.bp_spacing );
        linker.node2 = create_undercircle( plot_settings.bp_spacing );
        linker.side_line1 = patch( [0,0],[0,0],[0.8 0.8 0.8],'edgecolor','none','clipping','off' ); % dummy for now -- will get redrawn later.
        linker.side_line2 = patch( [0,0],[0,0],[0.8 0.8 0.8],'edgecolor','none','clipping','off' ); % dummy for now -- will get redrawn later.
        linker.outarrow1  = patch( [0,0],[0,0],[0.8 0.8 0.8],'edgecolor','none','clipping','off' ); % dummy for now -- will get redrawn later.
        linker.outarrow2  = patch( [0,0],[0,0],[0.8 0.8 0.8],'edgecolor','none','clipping','off' ); % dummy for now -- will get redrawn later.
        setappdata( gca, linker.linker_tag, linker );
        send_to_back( linker.line_handle );
        send_to_back( linker.side_line1 );
        send_to_back( linker.side_line2 );
        send_to_back( linker.outarrow1 );
        send_to_back( linker.outarrow2 );
    case {'tertcontact_intradomain','tertiary_contact_intradomain'}
        linker.type = 'tertcontact_intradomain';
        linker.line_handle = plot( [0,0],[0,0],'color',[0.8 0.8 0.8],'linestyle','-','linewidth',2.5,'clipping','off' ); % dummy for now -- will get redrawn later.
        % don't need to make node1 -- should be covered by interdomain.
        linker.node2 = create_undercircle( plot_settings.bp_spacing );
        setappdata( gca, linker.linker_tag, linker );
        send_to_back( linker.line_handle );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = create_undercircle( bp_spacing );
t = linspace(0, 2*pi);
r = bp_spacing/3;
x = r*cos(t);
y = r*sin(t);
h = patch( x,y,'w','edgecolor',[0.8,0.8,0.8],'facecolor','w','linewidth',2);
send_to_back( h );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linkers (base pairs & arrow connectors)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function too_short = linker_is_too_short_for_display( linker, plot_settings )
too_short = 0;
residue1 = getappdata( gca, linker.residue1 );
residue2 = getappdata( gca, linker.residue2 );
if isfield( linker, 'relpos1' ) && isfield( linker, 'relpos2' )
    if ~isfield( residue1, 'plot_pos' )  residue1.plot_pos = get_plot_pos( residue1, linker.relpos1(1,:) ); end;
    if ~isfield( residue2, 'plot_pos' )  residue2.plot_pos = get_plot_pos( residue2, linker.relpos2(end,:) ); end;
    if strcmp(linker.type,'stack' )
        if ( norm( residue1.plot_pos - residue2.plot_pos ) < 1.5 * plot_settings.bp_spacing ) too_short = 1; return; end;
    end
    if strcmp(linker.type,'arrow' )
        if ( norm( residue1.plot_pos - residue2.plot_pos ) < 1.5 * plot_settings.spacing ) too_short = 1;  return; end;
    end
end
    
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
% does not seem necessary...
%setappdata( gca, linker.linker_tag, linker ); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_arrow( h, ctr, v, visible, spacing, add_stem );
x = v * 1.5 * [0 1; -1 0]; % cross direction
set( h, 'visible', visible);
a  = [ ...
    ctr - spacing/3*v+spacing/5*x;
    ctr - spacing/6*v+spacing/10*x;
    ctr + spacing*0*v+spacing/15*x;
    ctr + spacing/6*v+spacing/20*x;
    ctr + spacing/2*v;
    ctr + spacing/6*v-spacing/20*x;
    ctr - spacing*0*v-spacing/15*x;
    ctr - spacing/6*v-spacing/10*x;
    ctr - spacing/3*v-spacing/5*x ...
    ];
if exist( 'add_stem', 'var' ) & add_stem
    a = [ a; ...
        ctr - spacing/3*v-spacing*0.075*x; 
        ctr - spacing/2*v-spacing*0.075*x; 
        ctr - spacing/2*v+spacing*0.075*x; 
        ctr - spacing/3*v+spacing*0.075*x ...
        ];
end
    
set( h, 'xdata', ...
    a(:,1) );
set( h, 'ydata', ...
    a(:,2) );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function linker = update_extra_arrows( linker, plot_pos, num_pos1, plot_settings );
num_extra_arrows = size(plot_pos,1)-2;
if ~isfield( linker, 'extra_arrows' )
    linker.extra_arrows = {};
    for i = 1:num_extra_arrows
        linker.extra_arrows{i} = patch( [0,0,0],[0,0,0],'k','clipping','off' );;
    end
end

% make the right number of extra arrows
for i = num_extra_arrows+1: length( linker.extra_arrows ); delete( linker.extra_arrows{i} ); end
for i = length( linker.extra_arrows )+1 : num_extra_arrows;  linker.extra_arrows{i} = patch( [0,0,0],[0,0,0],'k','clipping','off' ); end;
linker.extra_arrows = linker.extra_arrows(1:num_extra_arrows);

% These are extra_arrows. Skip the 'usual' arrow that connects plot_pos1 and plot_pos2. 
which_segment = [1:(num_pos1-1), (num_pos1+1):size(plot_pos,1)-1];
assert( num_extra_arrows == length( which_segment) );
for i = 1:num_extra_arrows;
    pos1 = plot_pos( which_segment(i), : );
    pos2 = plot_pos( which_segment(i)+1, : );
    ctr = (pos1+pos2)/2; % center of connecting line
    v = pos2 - pos1; v = v/norm(v); % unit vector from res1 to res2
    show_arrow = plot_settings.show_extra_arrows & norm( pos2 - pos1 ) >= 5 * plot_settings.bp_spacing;
    if ( show_arrow ) visible = 'on'; else; visible = 'off'; end;
    update_arrow( linker.extra_arrows{ i }, ctr, v, visible, plot_settings.spacing );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pos1 = nudge_pos( pos1, pos2, bp_spacing );
v = pos2 - pos1; 
v = v/norm(v);
pos1 = pos1 +  (bp_spacing/5)*v;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_pos = get_plot_pos( res_tag, relpos );
if ischar( res_tag ) 
    residue = getappdata( gca, res_tag );
else
    residue = res_tag;
end
helix = getappdata( gca, residue.helix_tag );
R = get_helix_rotation_matrix( helix );
plot_pos = repmat(helix.center,size(relpos,1),1) + relpos*R;

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
function base_paired = check_for_base_pair( res_tag1, res_tag2 )
residue1 = getappdata( gca, res_tag1 );
base_paired = false;
for i = 1:length( residue1.linkers )
    linker_tag = residue1.linkers{i};
    if ~isappdata( gca, linker_tag ) fprintf( 'Could not find linker %s\n', linker_tag ); continue; end;
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
function linker = update_tertiary_contact( linker, plot_pos, plot_settings );
tertiary_contact = getappdata( gca, linker.tertiary_contact );
    
if isfield( plot_settings, 'show_tertiary_contacts' )
    if plot_settings.show_tertiary_contacts; visible = 'on'; else; visible = 'off'; end;
    linker = set_linker_visibility( linker, visible );
end

residue1 = getappdata( gca, tertiary_contact.associated_residues1{1} );
residue2 = getappdata( gca, tertiary_contact.associated_residues2{1} );

if strcmp( linker.type, 'tertcontact_interdomain' )
    % double color lines for interdomain;
    side_line1_pos = []; side_line2_pos = [];
    for i = 1:length( plot_pos ) - 1
        segv = plot_pos(i+1,:) - plot_pos(i,:);
        segv = segv/norm(segv);
        segv = segv * [0 1; -1 0] * plot_settings.bp_spacing/8; % rotate
        side_line1_pos = [side_line1_pos; plot_pos(i,:)-segv; plot_pos(i+1,:)-segv ];
        side_line2_pos = [side_line2_pos; plot_pos(i,:)+segv; plot_pos(i+1,:)+segv ];
    end
    set( linker.side_line1, 'xdata', [side_line1_pos(:,1); plot_pos(end:-1:1,1)], 'ydata', [side_line1_pos(:,2); plot_pos(end:-1:1,2)] );
    set( linker.side_line2, 'xdata', [side_line2_pos(:,1); plot_pos(end:-1:1,1)], 'ydata', [side_line2_pos(:,2); plot_pos(end:-1:1,2)] );

    if ( isfield( linker, 'show_split_arrows' )  && linker.show_split_arrows ) arrow_visible = 'on'; else; arrow_visible = 'off'; end;
    outarrow_size = 1.5*plot_settings.spacing;
    linker = update_outarrow( linker, plot_pos, residue1, outarrow_size,  'outarrow1','outarrow_label1', arrow_visible, plot_settings, 1 );
    linker = update_outarrow( linker, plot_pos, residue2, outarrow_size,  'outarrow2','outarrow_label2', arrow_visible, plot_settings, 2 );
    if ( isfield( linker, 'show_split_arrows' )  && linker.show_split_arrows && isfield( plot_settings,'show_split_arrow_lines') )
        if ( plot_settings.show_split_arrow_lines ) line_visible = 'on'; else; line_visible = 'off'; end;
        set( linker.line_handle, 'visible',line_visible );
        if isfield( linker, 'vtx' )
            vtx_visible = line_visible;
            if isfield( plot_settings, 'show_linker_controls') & ~plot_settings.show_linker_controls;  vtx_visible = 'off'; end;
            for i = 1:length( linker.vtx ), set( linker.vtx{i}, 'visible', vtx_visible ); end;
        end;
    end
end

% colors
set( linker.line_handle, 'xdata', plot_pos(:,1), 'ydata', plot_pos(:,2) );

if isfield( residue1, 'rgb_color' ) rescolor1 = residue1.rgb_color; else; rescolor1 = [0,0,0]; end;
if isfield( residue2, 'rgb_color' ) rescolor2 = residue2.rgb_color; else; rescolor2 = [0,0,0]; end;
% make color informative about *other* domain
color1 = fade_color( rescolor2 );
color2 = fade_color( rescolor1 );
if isfield(plot_settings,'tertiary_contact_domain_coloring' ) & ~plot_settings.tertiary_contact_domain_coloring
    color1 = [0.9 0.9 0.9];
    color2 = [0.9 0.9 0.9];
end
if strcmp( linker.type, 'tertcontact_interdomain' )
    set( linker.node1, 'edgecolor',color1);
    set( linker.node2, 'edgecolor',color2);
    set( linker.side_line1, 'facecolor', color1 );
    set( linker.side_line2, 'facecolor', color2 );
    if isfield( linker, 'outarrow1' ); set( linker.outarrow1, 'facecolor',rescolor2 ); end;  
    if isfield( linker, 'outarrow2' ); set( linker.outarrow2, 'facecolor',rescolor1 ); end;
    if isfield( linker, 'outarrow_label1' ); set( linker.outarrow_label1, 'color',rescolor2 ); end;  
    if isfield( linker, 'outarrow_label2' ); set( linker.outarrow_label2, 'color',rescolor1 ); end;
    linker_visible = get(linker.node1,'visible');
    if isfield( linker, 'show_split_arrows' ) & linker.show_split_arrows
        set( linker.outarrow1, 'visible', linker_visible );
        set( linker.outarrow2, 'visible', linker_visible );
        set( linker.side_line1, 'visible','off');
        set( linker.side_line2, 'visible','off');
    else
        set( linker.outarrow1, 'visible', 'off' );
        set( linker.outarrow2, 'visible', 'off' );
        set( linker.side_line1, 'visible',linker_visible );
        set( linker.side_line2, 'visible',linker_visible );
    end
else
    assert( strcmp( linker.type, 'tertcontact_intradomain' ) );
    set( linker.line_handle, 'linewidth', 2*get_arrow_linewidth( plot_settings.fontsize ) );
    if any( strcmp( tertiary_contact.associated_residues1, linker.residue1 ) ) % in domain 1
        set( linker.node2, 'edgecolor',color1);
        set( linker.line_handle, 'color',color1);
    else % in domain 2
        assert( any( strcmp( tertiary_contact.associated_residues2, linker.residue1 ) ) );
        set( linker.node2, 'edgecolor',color2);
        set( linker.line_handle, 'color',color2);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function linker = update_tertiary_arrow_label( linker, arrow_label, default_plot_pos, arrow_visible, plot_settings );
if ~isfield( linker, arrow_label )
    h = text( 0, 0, '.' );
    linker = setfield( linker, arrow_label, h );
    setappdata( gca, linker.linker_tag, linker );
end
tertiary_contact = getappdata( gca, linker.tertiary_contact );
h = getfield(linker, arrow_label);
if ~isvalid( h ) return; end;
set( h, 'string', strrep(tertiary_contact.name,'_','-'), 'Position', default_plot_pos, 'visible',arrow_visible,'fontsize', plot_settings.fontsize*0.75 );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function linker = update_outarrow( linker, plot_pos, residue, outarrow_size, outarrow_fieldname, outarrow_label_fieldname, arrow_visible, plot_settings, which_res )
if (isfield(plot_settings,'image_representation') & ~strcmp(plot_settings.image_representation,'image_boundary') ) return; end;
if ~isfield( linker, outarrow_fieldname ) return; end;

% if this is the ligand side of an interdomain outarrow, 
% only show arrow if its the first split one.
if which_res == 1 && isfield( residue, 'ligand_partners' ) arrow_visible = check_first_linker_outarrow( linker, residue, arrow_visible ); end;

if ( which_res == 2 ) plot_pos = plot_pos(end:-1:1,:); end;
if isfield( residue, 'image_handle' )
    [v,start_pos,pointing_out_of_polygon] = first_crossing( [get(residue.image_handle,'XData'),get(residue.image_handle,'YData')], plot_pos );
    if ( ~pointing_out_of_polygon ) arrow_visible = 'off'; end;
else
    v = plot_pos(2,:) - plot_pos(1,:);  v = v /norm(v);
    start_pos = plot_pos(1,:);
end
update_arrow( getfield(linker,outarrow_fieldname), start_pos + v*outarrow_size*0.5, v, arrow_visible, outarrow_size, 1 );
linker = update_tertiary_arrow_label( linker, outarrow_label_fieldname, start_pos + v*outarrow_size, arrow_visible, plot_settings );
set_text_alignment( getfield( linker, outarrow_label_fieldname ), v );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  arrow_visible = check_first_linker_outarrow( linker, residue, arrow_visible );
sister_linker_tags = get_tags( 'Linker','interdomain',residue.linkers );
for i = 1:length( sister_linker_tags )
    sister_linker = getappdata( gca, sister_linker_tags{i} );
    if ~isfield( sister_linker, 'show_split_arrows' ) || ~sister_linker.show_split_arrows; continue; end
    if ~strcmp(sister_linker.linker_tag,linker.linker_tag);
        arrow_visible = 'off';
    end
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function check_interdomain( linker, plot_settings )
% for show/hide interdomain_noncanonical_pairs
if ~isfield( plot_settings, 'show_interdomain_noncanonical_pairs' ) return; end;
setting = 1;
if ~plot_settings.show_interdomain_noncanonical_pairs
    if isfield( linker, 'interdomain' ) & linker.interdomain
        setting = 0;
    end
end
if setting; visible = 'on'; else; visible = 'off'; end;
linker = set_linker_visibility( linker, visible );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_ligand_linker_visibility( linker, plot_settings );
if ~isfield( plot_settings, 'show_ligand_linkers' ); return; end;
if ( plot_settings.show_ligand_linkers ) visible = 'on'; else; visible = 'off'; end;
set( linker.line_handle, 'visible', visible );

    

