function savedata = save_drawing( filename );
% pull information needed to render drawing from current figure ('gca'), and
% save to a JSON file.
%
% (C) R. Das, Stanford University, 2017

tic
fprintf( 'Preparing drawing...\n' );
savedata = get_drawing();
toc

tic
fprintf( 'Outputting JSON to: %s\n', filename );
savejson( '', savedata, filename );
toc


