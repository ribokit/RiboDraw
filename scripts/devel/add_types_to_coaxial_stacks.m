% silly script used during development to cleanup objects (e.g., associated_domains --> associated_selections)

vals = getappdata( gca );
objnames = fields( vals );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'CoaxialStack_' ) );
        selection = getappdata( gca, objnames{n} );
        selection.type = 'coaxial_stack';
        setappdata( gca, [strrep( objnames{n}, 'CoaxialStack','Selection'),'_coaxial_stack'], selection );
        rmappdata( gca, objnames{n} );
    end
    if ~isempty( strfind( objnames{n}, 'Selection_' ) );
        selection = getappdata( gca, objnames{n} );
        if isfield( selection, 'domain_tag' );
            selection = rmfield( selection, 'domain_tag' );
        end
        selection.selection_tag = objnames{n};
        setappdata( gca, objnames{n}, selection );
    end
    if ~isempty( strfind( objnames{n}, 'Residue' ) ) | ...
        ~isempty( strfind( objnames{n}, 'Helix' ) )
        obj = getappdata( gca, objnames{n} );
        if isfield( obj, 'associated_domains' )
            obj.associated_selections = obj.associated_domains;
            obj = rmfield( obj, 'associated_domains');
            setappdata( gca, objnames{n}, obj );
        end
        if isfield( obj, 'associated_selections' )
            associated_selections = obj.associated_selections;
            new_selections = {};
            for k = 1:length( associated_selections )
                selection_tag = associated_selections{k};
                if ~isempty( strfind( selection_tag, 'CoaxialStack' ) )
                    selection_tag = [strrep( selection_tag, 'CoaxialStack','Selection'),'_coaxial_stack'];
                end
                new_selections{k} = selection_tag;
            end
            obj.associated_selections = new_selections;
            setappdata( gca, objnames{n}, obj );
        end
    end
end