function residue = draw_fill_and_ring_circle( residue, plot_settings )
% residue = draw_fill_and_ring_circle( residue, plot_settings )
% 
% Draw a circle under the residue 
%
% Note: this function does not move the circle to the back of the
%  drawing -- that needs to be handled by a call to MOVE_STUFF_TO_BACK later.
% 
% (C) Rhiju Das, Stanford University, 2019

assert( isfield( residue, 'fill_color') || isfield( residue, 'ring_color') );
if ~exist( 'plot_settings', 'var' ) plot_settings = getappdata(gca, 'plot_settings' ); end;

residue = draw_circle( residue, 'show_fill_circles', 'fill_color','fill_circle_handle', 2.3, plot_settings, 0.8 );
residue = draw_circle( residue, 'show_ring_circles', 'ring_color','ring_circle_handle', 3.5, plot_settings, 0.9 );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function residue = draw_circle( residue, setting_name, color_field_name, handle_field_name, circle_size, plot_settings, layer_level );

if ( ~isfield( plot_settings, setting_name) || getfield( plot_settings, setting_name ) ); 
    if isfield( residue, color_field_name); 
        if( ~isfield( residue, handle_field_name ) | ~isvalid( getfield(residue,handle_field_name) ) )
            h = create_fill_circle( plot_settings.bp_spacing );
            residue = setfield( residue, handle_field_name, h );
            setappdata( h, 'layer_level', layer_level ); % just above top_of_back (1)
            setappdata( h, 'res_tag', residue.res_tag );
        end
        [x,y] = get_fill_circle_xy( circle_size * plot_settings.bp_spacing/10 );
        h = getfield( residue, handle_field_name );
        set( h, ...
            'XData', x + residue.plot_pos(:,1), ...
            'YData', y + residue.plot_pos(:,2) );
        set( h, 'facecolor', getfield(residue, color_field_name ) );
        set( h, 'edgecolor', 'none');
    end
else
    if isfield( residue, handle_field_name );
        residue = rmgraphics( residue, {handle_field_name} );
    end
end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = create_fill_circle( bp_spacing );
[x,y] = get_fill_circle_xy( 10 * bp_spacing/2 );
h = patch( x,y,'w','edgecolor','none','facecolor','w','linewidth',1);
send_to_top_of_back( h );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,y] = get_fill_circle_xy( r );
t = linspace(0, 2*pi);
x = r*cos(t);
y = r*sin(t);


