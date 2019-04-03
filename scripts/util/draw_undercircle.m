function residue = draw_undercircle( residue, plot_settings )
% residue = draw_undercircle( residue, plot_settings )
% 
% Draw a circle under the residue 
%
% Note: this function does not move the circle to the back of the
%  drawing -- that needs to be handled by a call to MOVE_STUFF_TO_BACK later.
% 
% (C) Rhiju Das, Stanford University, 2019

assert( isfield( residue, 'undercircle_face_color') || isfield( residue, 'undercircle_ring_color') );
if ~exist( 'plot_settings', 'var' ) plot_settings = getappdata(gca, 'plot_settings' ); end;
bp_spacing = plot_settings.bp_spacing;

if ( ~isfield( plot_settings, 'show_undercircles') || plot_settings.show_undercircles ); 
    if isfield( residue, 'undercircle_face_color'); 
        if( ~isfield( residue, 'undercircle_handle' ) | ~isvalid( residue.undercircle_handle ) )
            residue.undercircle_handle = create_undercircle( bp_spacing );
            setappdata( residue.undercircle_handle, 'layer_level', 0.8 ); % just above top_of_back (1)
            setappdata( residue.undercircle_handle, 'res_tag', residue.res_tag );
        end
        [x,y] = get_undercircle_xy( 2.3 * plot_settings.bp_spacing/10 );
        set( residue.undercircle_handle, ...
            'XData', x + residue.plot_pos(:,1), ...
            'YData', y + residue.plot_pos(:,2) );
        set( residue.undercircle_handle, 'facecolor', residue.undercircle_face_color );
        set( residue.undercircle_handle, 'edgecolor', 'none');
    end
    if isfield( residue, 'undercircle_ring_color'); 
        if( ~isfield( residue, 'undercircle_handle2' ) | ~isvalid( residue.undercircle_handle2 ) )
            residue.undercircle_handle2 = create_undercircle( bp_spacing );
            setappdata( residue.undercircle_handle2, 'layer_level', 0.9 ); % just above top_of_back (1) 
            setappdata( residue.undercircle_handle2, 'res_tag', residue.res_tag );
        end
        [x,y] = get_undercircle_xy( 3.2 * plot_settings.bp_spacing/10 );
        set( residue.undercircle_handle2, ...
            'XData', x + residue.plot_pos(:,1), ...
            'YData', y + residue.plot_pos(:,2) );
        set( residue.undercircle_handle2, 'facecolor', residue.undercircle_ring_color );
        set( residue.undercircle_handle2, 'edgecolor', 'none');
    end
else
    residue = rmgraphics( residue, {'undercircle_handle','undercircle_handle2'} );
end
   
function h = create_undercircle( bp_spacing );
[x,y] = get_undercircle_xy( 10 * bp_spacing/2 );
h = patch( x,y,'w','edgecolor','none','facecolor','w','linewidth',1);
send_to_top_of_back( h );

function [x,y] = get_undercircle_xy( r );
t = linspace(0, 2*pi);
x = r*cos(t);
y = r*sin(t);


