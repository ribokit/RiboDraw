function set_text_alignment( h, v )
% set_text_alignment( h, v )
% 
% Set horizontal and vertical alignment of a text handle (h) based
%  on the vector of that handle from the thing it labels (v).
%
% (C) R. Das, Stanford University, 2017

theta = atan2( v(2), v(1) );
theta =  45 * round( (theta * 180/pi)/45 );
theta = mod( theta, 360 );
switch theta
    case 0
        set( h,'horizontalalign','left','verticalalign','middle');
    case 45
        set( h,'horizontalalign','left','verticalalign','bottom');
    case 90
        set( h,'horizontalalign','center','verticalalign','bottom');
    case 135
        set( h,'horizontalalign','right','verticalalign','bottom');
    case 180
        set( h,'horizontalalign','right','verticalalign','middle'); 
    case 225
        set( h,'horizontalalign','right','verticalalign','top'); 
    case 270
        set( h,'horizontalalign','center','verticalalign','top');
    case 315
        set( h,'horizontalalign','left','verticalalign','top'); 
end
