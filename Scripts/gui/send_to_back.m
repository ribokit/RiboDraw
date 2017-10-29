function send_to_back( h )
%uistack( h, 'bottom' );

%handles = get( gca, 'Children' );
%if exist( 'h', 'var' ) & ~isequal( h, handles(1) )
%    fprintf( 'Sending most recent graphical object to back, but its not the specified object!\n' );
%end
%set( gca, 'Children', circshift(handles,-1) );

setappdata( h, 'send_to_back', 1 );



