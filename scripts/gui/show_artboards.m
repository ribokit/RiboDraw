function show_artboards()

%set( gcf, 'color', [0.98 0.98 0.98 ] );
%axis on
%box on
%set(gca,'xtick',[],'ytick',[]);
set( gcf, 'color', [1 1 1] );
axis image;


xlim = get(gca,'xlim');
ylim = get(gca,'ylim');

nudge = 0;
setup_artboard_line( 'artboard_topline',    xlim + [-nudge,nudge], ylim(1)*[1 1], 'v' );
setup_artboard_line( 'artboard_bottomline', xlim + [-nudge,nudge], ylim(2)*[1 1], 'v' );
setup_artboard_line( 'artboard_leftline',   xlim(1)*[1 1],     ylim + [-nudge,nudge],  'h' );
setup_artboard_line( 'artboard_rightline',  xlim(2)*[1 1],     ylim + [-nudge,nudge],  'h' );
set(gca,'xlim',xlim);
set(gca,'ylim',ylim);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function setup_artboard_line( tag, xdata, ydata, constraint );

if isappdata( gca, tag )
    set( getappdata( gca, tag), 'visible','on' );
else
    h = plot( xdata, ydata, 'color', [0.7 0.7 1],'linew',1,'clipping','off' );
    draggable( h, constraint,[-inf inf],'endfcn', @update_artboards ); %@update_artboard_line);
    setappdata( h,'artboard_line_tag',tag);
    setappdata( gca,tag,h);
end