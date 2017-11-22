function delete_crosshair();
% delete_crosshair();
%
%  Delete the temporary crosshair that shows up
%    when dragging residues or boxes or linker vertices.
%
% (C) R. Das, Stanford University, 2017

if isappdata( gca, 'vertical_crosshair' )
    delete( getappdata( gca, 'vertical_crosshair' ) );
    rmappdata( gca, 'vertical_crosshair' );
end
if isappdata( gca, 'horizontal_crosshair' )
    delete( getappdata( gca, 'horizontal_crosshair' ) );
    rmappdata( gca, 'horizontal_crosshair' );
end
