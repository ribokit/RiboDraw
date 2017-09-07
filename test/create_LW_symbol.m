function h = create_LW_symbol( edge, orientation, bp_spacing );
switch edge
    case 'W'
        t = linspace(0, 2*pi);
        r = bp_spacing/10;
    case 'H'
        t = [0 pi/2 pi 3*pi/2]+pi/4;
        r = bp_spacing/10 * sqrt(2);
    case 'S'
        t = [0 2*pi/3 2*pi*2/3];
        r = bp_spacing/10 * sqrt(3);
    otherwise
        fprintf( 'PROBLEM: edge should be W, H, S\n' );
end
x = r*cos(t);
y = r*sin(t);
h = patch( x,y,'w','edgecolor','k');

switch orientation
    case 'C'
        set( h, 'facecolor', 'k' );
    case 'T'
        set( h, 'facecolor', 'w' );
    otherwise
        set( h, 'facecolor', 'r' );
end

