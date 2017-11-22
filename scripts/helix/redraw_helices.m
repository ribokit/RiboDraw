function redraw_helices()
% redraw_helices()
%
% Runs draw_helix() again for all helices. 
% May not be in use anymore due to 
%  handling of graphics objects by other functions.
% 
% (C) R. Das, Stanford University, 2017

vals = getappdata( gca );
objnames = fields( vals );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Helix_' ) );
        helix = getappdata( gca, objnames{n} );
        draw_helix( helix );
    end
end
