vals = getappdata( gca );
objnames = fields( vals );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Residue_' ) );
        figure_residue = getappdata( gca, objnames{n} );
        if isfield( figure_residue, 'tickrot' ) 
            figure_residue = rmfield( figure_residue, 'tickrot' ); 
        end;
        setappdata( gca, objnames{n}, figure_residue );
    end
end