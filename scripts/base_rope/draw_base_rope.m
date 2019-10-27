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

res_tag_sets = get_RNA_chains();
coords_sets = {};
for j = 1:length( res_tag_sets )
    res_tags = res_tag_sets{j};
    coords = [];
    for i = 1:length( res_tags )
        residue = getappdata( gca, res_tags{i} );
        if isfield( residue, 'plot_pos' )
            coords = [coords; residue.plot_pos ];
        end
    end
    coords_sets{j} = coords;
end

x = [];
y = [];
for j = 1:length( coords_sets )
    coords = coords_sets{j};
    if length( coords ) == 0; continue; end;
    N = size( coords, 1 );
    t = [1:(1/5):N];
    interp_method = 'pchip';
    % the NaN should put spaces between the chains.
    x = [x, interp1( 1:N, coords(:,1), t, interp_method ),NaN];
    y = [y, interp1( 1:N, coords(:,2), t, interp_method ),NaN];
end

if length( x ) == 0; return; end;

if ~isfield( base_rope, 'line_handle' );
    base_rope.line_handle = plot( x, y, '-','linew',6,'color',[[1,1,1]*0.7, 0.3]);
    setappdata(  base_rope.line_handle, 'layer_level', 3 )
end
if ~isfield( base_rope, 'line_handle2' );
    base_rope.line_handle2 = plot( x, y, '-','linew',4,'color',[[1,1,1]*0.9, 0.3]);
    setappdata( base_rope.line_handle2, 'layer_level', 3 )
end

plot_setting = get_plot_settings();
set( base_rope.line_handle, 'xdata', x, 'ydata', y, 'linew', 0.5*plot_settings.fontsize );
set( base_rope.line_handle2, 'xdata', x, 'ydata', y, 'linew', 0.5*plot_settings.fontsize*2/3 );

setappdata( gca, 'BaseRope', base_rope );

