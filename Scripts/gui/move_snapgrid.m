function move_snapgrid(h)
% snap to grid during movement.
% show crosshairs too

% works for both text (residue) and rectangle (helix).
if strcmp( h.Type, 'line' )
    % line/symbol
    pos = [ get( h, 'XData' ), get( h, 'YData' ) ];
    res_center = pos;
else
    pos = get(h,'Position');
    if length( pos ) == 4 % rectangle
        if isappdata( h, 'selection_tag' )
            % need to do some math -- figure out where some component
            % residue is going.
            selection = getappdata( gca, getappdata( h, 'selection_tag' ));
            residue = getappdata( gca, selection.associated_residues{1} );
            init_pos = getappdata(h,'initial_position');
            res_center = pos(1:2) - init_pos(1:2) + residue.plot_pos;
        else % helix centers live on grid
            res_center = pos(1:2)+ pos(3:4)/2;
        end
    else
        res_center = pos(1:2); % text
    end
end

% Computing the new position of the rectangle
plot_settings = getappdata(gca,'plot_settings');
grid_spacing = plot_settings.spacing/4;
new_position = round(res_center/grid_spacing)*grid_spacing;

% Updating the rectangle' XData and YData properties
delta = new_position - res_center;
pos(1:2) = pos(1:2) + delta;

if strcmp( h.Type, 'line' )
    set(h,'XData',pos(1),'YData',pos(2) );
else
    set(h,'Position',pos );    
end

make_crosshair( pos );
