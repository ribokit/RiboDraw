function draw_base_rope();
% draw_base_rope();
%
% Draw a smooth 'rope' under all the bases.
% Later, create separate ropes by chain.


plot_settings = get_plot_settings();
if ~isfield( plot_settings, 'show_base_rope' ) || ~plot_settings.show_base_rope; 
    % should not be a base rope!
    if isappdata( gca, 'BaseRope' );
        base_rope = getappdata( gca, 'BaseRope' );
        rmgraphics( base_rope, {'line_handle','line_handle2'} );
        rmappdata( gca, 'BaseRope' );
    end
    return;
end

if ~isappdata( gca, 'BaseRope' ); setappdata( gca, 'BaseRope', struct()  ); end
base_rope = getappdata( gca, 'BaseRope' );

res_tags = get_res();
coords = [];
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    if isfield( residue, 'plot_pos' )
        coords = [coords; residue.plot_pos ];
    end
end

N = size( coords, 1 );
t = [1:(1/5):N];
interp_method = 'spline';
x = interp1( 1:N, coords(:,1), t, interp_method );
y = interp1( 1:N, coords(:,2), t, interp_method );

if ~isfield( base_rope, 'line_handle' );
    base_rope.line_handle = plot( x, y, '-','linew',6,'color',[[1,1,1]*0.7, 0.3]);
    setappdata(  base_rope.line_handle, 'layer_level', 3 )
end
if ~isfield( base_rope, 'line_handle2' );
    base_rope.line_handle2 = plot( x, y, '-','linew',4,'color',[[1,1,1]*0.9, 0.3]);
    setappdata( base_rope.line_handle2, 'layer_level', 3 )
end

set( base_rope.line_handle, 'xdata', x );
set( base_rope.line_handle, 'ydata', y );
set( base_rope.line_handle2, 'xdata', x );
set( base_rope.line_handle2, 'ydata', y );

setappdata( gca, 'BaseRope', base_rope );

