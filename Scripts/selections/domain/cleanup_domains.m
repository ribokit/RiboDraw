function cleanup_domains()
% cleanup_domains()

% Cleanup 1: make sure there are no 'stray' domains associated with
% residues.
res_tags = get_tags( 'Residue' );
for i = 1:length( res_tags )
    res_tag = res_tags{i};
    residue = getappdata( gca, res_tag );
    if ~isfield( residue, 'associated_selections' ); continue; end; 
    selections = residue.associated_selections;
    for  k = 1:length( selections )
        selection = selections{k};
        if ~isappdata( gca, selection )
            fprintf( 'Could not find selection %s for residue %s -- will delete this as associated_selection\n', ...
                selection, res_tag )
            residue.associated_selections = setdiff( residue.associated_selections, selection );
        end
        setappdata( gca, res_tag, residue );
    end
end

% Cleanup 2: fix names of domains.
tags = get_tags( 'Selection' );
for i = 1:length( tags )
    tag = tags{i};
    selection = getappdata( gca, tag );
    if strcmp( selection.type, 'domain' )
        if ( length( tag ) < 7 | ~strcmp( tag(end-6:end), '_domain' ) )
            new_tag = [ tag,'_domain' ];
            fprintf( 'Changing name of %s to %s\n', tag, new_tag );
            selection.selection_tag = new_tag;
            setappdata( gca, new_tag, selection );
            rmappdata( gca, tag );

            for i = 1:length( res_tags )
                res_tag = res_tags{i};
                residue = getappdata( gca, res_tag );
                if ~isfield( residue, 'associated_selections' ); continue; end;
                if any( strcmp( residue.associated_selections, tag ) )
                    residue.associated_selections = setdiff( residue.associated_selections, tag );
                    residue.associated_selections = [residue.associated_selections, new_tag ];
                    setappdata( gca, res_tag, residue );
                end
            end
        end
    end
end



