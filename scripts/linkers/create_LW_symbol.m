function h = create_LW_symbol( edge, orientation, bp_spacing );
% h = create_LW_symbol( edge, orientation, bp_spacing );
%
% Inputs
%   edge = 'W', 'H', or 'S' for Watson-Crick, Hoogsteen, or Sugar
%   orientation = 'C' or 'T'
%   bp_spacing  = from plot_settings, how many pixels between nucleotides in a base pair.
%
% Output
%   h = handle to a 'patch' graphic object.
%
% (C) R. Das, Stanford University, 2017

switch edge
    case 'W'
        t = linspace(0, 2*pi);
        r = bp_spacing/10;
    case 'H'
        t = [0 pi/2 pi 3*pi/2]+pi/4;
        r = bp_spacing/10 * sqrt(2);
    case 'S'
        t = [0 2*pi/3 2*pi*2/3];
        r = bp_spacing/10 * 1.5*sqrt(3)/2;
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

set( h, 'clipping','off' );

