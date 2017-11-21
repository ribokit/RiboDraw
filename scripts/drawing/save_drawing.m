function savedata = save_drawing( filename );
% drawing = save_drawing( filename );
%
% Pulls information needed to render drawing from current figure ('gca'), and
% save to a JSON file or .mat MATLAB workspace file.
%
% INPUT
%   filename = name of .json or .mat file with drawing
%
% OUTPUT
%   savedata = MATLAB 'drawing' data structure with all the saved info
%
% See also: GET_DRAWING.
%
% (C) R. Das, Stanford University, 2017

tic
fprintf( 'Preparing drawing...\n' );
savedata = get_drawing();
toc

tic
if length(filename) > 4 & strcmp( filename( end-3:end ), '.mat' )
    fprintf( 'Outputting MATLAB workspace to: %s\n', filename );
    drawing = savedata;
    save( filename, 'drawing' );
else
    fprintf( 'Outputting JSON to: %s\n', filename );
    savejson( '', savedata, filename );    
end
toc


