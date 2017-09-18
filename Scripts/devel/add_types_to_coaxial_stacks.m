vals = getappdata( gca );
objnames = fields( vals );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'CoaxialStack_' ) );
        domain = getappdata( gca, objnames{n} );
        domain.type = 'coaxial_stack';
        setappdata( gca, objnames{n}, domain );
    end
end
