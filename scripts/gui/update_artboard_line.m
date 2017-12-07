function update_artboard_line(h)

artboard_line_tag = getappdata( h, 'artboard_line_tag' );

xlim = get(gca,'xlim');
ylim = get(gca,'ylim');
switch artboard_line_tag
    case 'artboard_topline'
        pos = get(h,'ydata'); 
        ylim(1) = pos(1);
    case 'artboard_bottomline'
        pos = get(h,'ydata'); 
        ylim(2) = pos(1);
    case 'artboard_leftline'
        pos = get(h,'xdata'); 
        xlim(1) = pos(1);
    case 'artboard_rightline'
        pos = get(h,'xdata'); 
        xlim(2) = pos(1);
    otherwise
        fprintf( 'Unrecognized artboard line tag: %s\n', artboard_line_tag );
end

set(gca,'xlim',xlim);
set(gca,'ylim',ylim);
