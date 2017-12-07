function hide_artboards()

set( gcf, 'color', 'w' );
axis off
tags = {'artboard_topline','artboard_bottomline','artboard_leftline','artboard_rightline'};
for i = 1:length( tags )
    if isappdata( gca, tags{i} );
        setappdata( getappdata( gca, tags{i} ), 'visible','off' );
    end
end
