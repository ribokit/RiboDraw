function rgb_color = pymol_RGB( colorname )
% rgb_color = pymol_RGB( colorname )
%
% grabbed from https://pymolwiki.org/index.php/Color_Values
%
% if not a pymol color, use rgb() package.
% 
% (C) R. Das, Stanford University

rgb_color = -1;
if ~ischar( colorname )
    rgb_color = rgb( colorname );
end
switch colorname
    case 'aquamarine'
        rgb_color = [0.5, 1.0, 1.0];%
    case 'black'
        rgb_color = [0.0, 0.0, 0.0];%
    case 'blue'
        rgb_color = [0.0, 0.0, 1.0];%
    case 'bluewhite'
        rgb_color = [0.85, 0.85, 1.00];%
    case 'br0'
        rgb_color = [0.1, 0.1, 1.0];%
    case 'br1'
        rgb_color = [0.2, 0.1, 0.9];%
    case 'br2'
        rgb_color = [0.3, 0.1, 0.8];%
    case 'br3'
        rgb_color = [0.4, 0.1, 0.7];%
    case 'br4'
        rgb_color = [0.5, 0.1, 0.6];%
    case 'br5'
        rgb_color = [0.6, 0.1, 0.5];%
    case 'br6'
        rgb_color = [0.7, 0.1, 0.4];%
    case 'br7'
        rgb_color = [0.8, 0.1, 0.3];%
    case 'br8'
        rgb_color = [0.9, 0.1, 0.2];%
    case 'br9'
        rgb_color = [1.0, 0.1, 0.1];%
    case 'brightorange'
        rgb_color = [1.0, 0.7, 0.2];%
    case 'brown'
        rgb_color = [0.65, 0.32, 0.17];%
    case 'carbon'
        rgb_color = [0.2, 1.0, 0.2];%
    case 'chartreuse'
        rgb_color = [0.5, 1.0, 0.0];%
    case 'chocolate'
        rgb_color = [0.555, 0.222, 0.111];%
    case 'cyan'
        rgb_color = [0.0, 1.0, 1.0];%
    case 'darksalmon'
        rgb_color = [0.73, 0.55, 0.52];%
    case 'dash'
        rgb_color = [1.0, 1.0, 0.0];%
    case 'deepblue'
        rgb_color = [0.25, 0.25, 0.65];%	deep
    case 'deepolive'
        rgb_color = [0.6, 0.6, 0.1];%
    case 'deeppurple'
        rgb_color = [0.6, 0.1, 0.6];%
    case 'deepsalmon'
        rgb_color = [1.0, 0.5, 0.5];%	duplicated?
    case 'deepsalmon'
        rgb_color = [1.00, 0.42, 0.42];%	duplicated?
    case 'deepteal'
        rgb_color = [0.1, 0.6, 0.6];%
    case 'density'
        rgb_color = [0.1, 0.1, 0.6];%
    case 'dirtyviolet'
        rgb_color = [0.70, 0.50, 0.50];%
    case 'firebrick'
        rgb_color = [0.698, 0.13, 0.13];%
    case 'forest'
        rgb_color = [0.2, 0.6, 0.2];%
    case 'gray'
        rgb_color = [0.5, 0.5, 0.5];%	american spelling
    case 'green'
        rgb_color = [0.0, 1.0, 0.0];%
    case 'greencyan'
        rgb_color = [0.25, 1.00, 0.75];%
    case 'grey'
        rgb_color = [0.5, 0.5, 0.5];%	english spelling
    case 'hotpink'
        rgb_color = [1.0, 0.0, 0.5];%
    case 'hydrogen'
        rgb_color = [0.9, 0.9, 0.9];%
    case 'lightblue'
        rgb_color = [0.75, 0.75, 1.0];%
    case 'lightmagenta'
        rgb_color = [1.0, 0.2, 0.8];%
    case 'lightorange'
        rgb_color = [1.0, 0.8, 0.5];%
    case 'lightpink'
        rgb_color = [1.00, 0.75, 0.87];%
    case 'lightteal'
        rgb_color = [0.4, 0.7, 0.7];%
    case 'lime'
        rgb_color = [0.5, 1.0, 0.5];%
    case 'limegreen'
        rgb_color = [0.0, 1.0, 0.5];%
    case 'limon'
        rgb_color = [0.75, 1.00, 0.25];%
    case 'magenta'
        rgb_color = [1.0, 0.0, 1.0];%
    case 'marine'
        rgb_color = [0.0, 0.5, 1.0];%
    case 'nitrogen'
        rgb_color = [0.2, 0.2, 1.0];%
    case 'olive'
        rgb_color = [0.77, 0.70, 0.00];%
    case 'orange'
        rgb_color = [1.0, 0.5, 0.0];%
    case 'oxygen'
        rgb_color = [1.0, 0.3, 0.3];%
    case 'palecyan'
        rgb_color = [0.8, 1.0, 1.0];%
    case 'palegreen'
        rgb_color = [0.65, 0.9, 0.65];%
    case 'paleyellow'
        rgb_color = [1.0, 1.0, 0.5];%
    case 'pink'
        rgb_color = [1.0, 0.65, 0.85];%
    case 'purple'
        rgb_color = [0.75, 0.00, 0.75];%
    case 'purpleblue'
        rgb_color = [0.5, 0.0, 1.0];%	legacy name
    case 'raspberry'
        rgb_color = [0.70, 0.30, 0.40];%
    case 'red'
        rgb_color = [1.0, 0.0, 0.0];%
    case 'ruby'
        rgb_color = [0.6, 0.2, 0.2];%
    case 'salmon'
        rgb_color = [1.0, 0.6, 0.6];%	was 0.5
    case 'sand'
        rgb_color = [0.72, 0.55, 0.30];%
    case 'skyblue'
        rgb_color = [0.20, 0.50, 0.80];%
    case 'slate'
        rgb_color = [0.5, 0.5, 1.0];%
    case 'smudge'
        rgb_color = [0.55, 0.70, 0.40];%
    case 'splitpea'
        rgb_color = [0.52, 0.75, 0.00];%
    case 'sulfur'
        rgb_color = [0.9, 0.775, 0.25];%	far enough from yellow
    case 'teal'
        rgb_color = [0.00, 0.75, 0.75];%
    case 'tv_blue'
        rgb_color = [0.3, 0.3, 1.0];%
    case 'tv_green'
        rgb_color = [0.2, 1.0, 0.2];%
    case 'tv_orange'
        rgb_color = [1.0, 0.55, 0.15];%
    case 'tv_red'
        rgb_color = [1.0, 0.2, 0.2];%
    case 'tv_yellow'
        rgb_color = [1.0, 1.0, 0.2];%
    case 'violet'
        rgb_color = [1.0, 0.5, 1.0];%
    case 'violetpurple'
        rgb_color = [0.55, 0.25, 0.60];%
    case 'warmpink'
        rgb_color = [0.85, 0.20, 0.50];%
    case 'wheat'
        rgb_color = [0.99, 0.82, 0.65];%
    case 'white'
        rgb_color = [1.0, 1.0, 1.0];%
    case 'yellow'
        rgb_color = [1.0, 1.0, 0.0];%
    case 'yelloworange'
        rgb_color = [1.0, 0.87, 0.37];%
    case 'gold'
        rgb_color = [1.000000000, 0.819607843, 0.137254902];
    otherwise
        rgb_color = rgb( colorname );
end

if ( sum(rgb_color) < 0.0 )
    fprintf( 'UNRECOGNIZED color! %s\n', colorname );
end

