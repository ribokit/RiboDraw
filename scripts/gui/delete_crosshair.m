function delete_crosshair();
if isappdata( gca, 'vertical_crosshair' )
    delete( getappdata( gca, 'vertical_crosshair' ) );
    rmappdata( gca, 'vertical_crosshair' );
end
if isappdata( gca, 'horizontal_crosshair' )
    delete( getappdata( gca, 'horizontal_crosshair' ) );
    rmappdata( gca, 'horizontal_crosshair' );
end
