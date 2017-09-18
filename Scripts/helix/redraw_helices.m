function redraw_helices()
% redraw_helices()
vals = getappdata( gca );
objnames = fields( vals );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Helix_' ) );
        helix = getappdata( gca, objnames{n} );
        undraw_helix( helix );
        draw_helix( helix );
    end
end
