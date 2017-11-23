function linker = create_linker_with_draggable_vtx( linker )
% linker = create_linker_with_draggable_vtx( linker )
%
% (C) R. Das, Stanford University.

linker.vtx = {};
nvtx = size(linker.plot_pos,1);
linker.vtx{1}  = create_endpoint_linker_vertex(linker.plot_pos(1,:), linker.linker_tag );
for i = 2:(nvtx-1)
    linker.vtx{i}  = create_draggable_linker_vertex(linker.plot_pos(i,:), linker.linker_tag  );
end
linker.vtx{nvtx}  = create_endpoint_linker_vertex( linker.plot_pos(nvtx,:), linker.linker_tag );
for i = 1:size( linker.plot_pos, 1 )
    set( linker.vtx{i}, 'xdata', linker.plot_pos(i,1), 'ydata', linker.plot_pos(i,2) );
end

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
linker     = getappdata( gca, linker_tag );
if isempty( linker ) return; end;
plot_settings = getappdata( gca, 'plot_settings' );

% special 'rearrangement' for tertcontact_interdomain.
if  strcmp( linker.type, 'tertcontact_interdomain' )
    tertiary_contact = getappdata( gca, linker.tertiary_contact );
    if ( h == linker.vtx{1} )
        res_tags = tertiary_contact.associated_residues1 ;
        for i = 2:length( res_tags )
            residue = getappdata( gca, res_tags{i} );
            if norm( residue.plot_pos - pos ) < plot_settings.bp_spacing/6
                res_tags1 = res_tags( [i, 1:i-1, i+1:end] );
                res_tags2 = tertiary_contact.associated_residues2;
                split_arrows = isfield( linker, 'show_split_arrows') && linker.show_split_arrows;
                tertiary_contact = setup_tertiary_contact( '', res_tags1, res_tags2, linker, 0, 0 );
                show_split_arrows( tertiary_contact.interdomain_linker, split_arrows );
                delete_tertiary_contact( linker.tertiary_contact, 0 );
                return;
            end
        end
    else
        assert( h == linker.vtx{end} );
        res_tags = tertiary_contact.associated_residues2;
        for i = 2:length( res_tags )
            residue = getappdata( gca, res_tags{i} );
            if norm( residue.plot_pos - pos ) < plot_settings.bp_spacing/6
                res_tags1 = tertiary_contact.associated_residues1;
                res_tags2 = res_tags( [i, 1:i-1, i+1:end] );
                split_arrows = isfield( linker, 'show_split_arrows') && linker.show_split_arrows;
                tertiary_contact = setup_tertiary_contact( '', res_tags1, res_tags2, linker, 0, 0 );
                show_split_arrows( tertiary_contact.interdomain_linker, split_arrows );
                delete_tertiary_contact( linker.tertiary_contact, 0 );
                return;
            end
        end
    end
end

% create new draggable symbol
h_new = create_draggable_linker_vertex( pos, linker_tag );

% install this new vertex in linker vertices.
if ( h == linker.vtx{1} )
    relpos = get_relpos_based_on_restag( pos, linker.residue1 );
    if ( norm( linker.relpos1(1,:) - relpos ) >= plot_settings.bp_spacing/6 )
        linker.relpos1 = [ linker.relpos1(1,:); relpos; linker.relpos1(2:end,:)];
        linker.vtx = [linker.vtx(1), {h_new}, linker.vtx(2:end)];
    else
        delete( h_new );
    end
else
    assert( h == linker.vtx{end} );
    relpos = get_relpos_based_on_restag( pos, linker.residue2 );
    if ( norm( linker.relpos2(end,:) - relpos ) >= plot_settings.bp_spacing/6 )
        linker.relpos2 = [ linker.relpos2(1:end-1,:); relpos; linker.relpos2(end,:)];
        linker.vtx = [linker.vtx(1:end-1), {h_new}, linker.vtx(end)];
    else
        delete( h_new );
    end
end

linker = draw_linker( linker );
rectify_linker( linker ); % auto-rectify!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function relpos = get_relpos_based_on_restag( plot_pos, res_tag );
residue = getappdata( gca, res_tag );
helix = getappdata( gca, residue.helix_tag );
relpos = get_relpos( plot_pos, helix );

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
            if ( norm( linker.relpos1(n,:) - linker.relpos1(1,:) ) < plot_settings.bp_spacing/6 ) 
                delete( h );
                linker.relpos1 = linker.relpos1( [1:n-1, n+1:end], : );
                linker.vtx = linker.vtx( [1:n-1, n+1:end] );
            end
            break;
        else
            n_off = n - n1;
            linker.relpos2( n_off, : ) = get_relpos_based_on_restag( pos, linker.residue2 );
            if ( norm( linker.relpos2( n_off, :) - linker.relpos2(end,:) ) < plot_settings.bp_spacing/6 )
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

linker = draw_linker( linker );
rectify_linker( linker ); % auto-rectify!

