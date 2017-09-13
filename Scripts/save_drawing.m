function savedata = save_drawing( filename );
% pull information needed to render drawing from current figure ('gca'), and
% save to a JSON file.
%
% (C) R. Das, Stanford University, 2017

savedata = get_drawing();
savejson( '', savedata, filename );


