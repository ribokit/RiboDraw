function cleanup_missing_linker_tags_in_residues()

res_tags = get_tags( 'Residue' );
linker_tags = get_tags( 'Linker' );
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i});
    if isfield( residue, 'linkers' );
        residue.linkers = intersect( residue.linkers, linker_tags' );
        setappdata( gca, res_tags{i}, residue );
    end    
end

