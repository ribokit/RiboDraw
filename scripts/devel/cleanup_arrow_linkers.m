function cleanup_arrow_linkers(resnum,chains)
% cleanup_arrow_linkers( resnum, chains )
%
% get rid of linkers that jump residue numbers
% used during development, but probably could be removed from the repo.
%
% (C) R. Das, Stanford University.

for i = 1:length(resnum)
    j = i + 1;
    if ( j > length( resnum ) ) continue; end;
    if ( chains(j) ~= chains(i) ) continue; end;    
    if ( resnum(j) ~= resnum(i)+1 ) 
        res_tag_i = sprintf('Residue_%s%d',chains(i),resnum(i));
        res_tag_j = sprintf('Residue_%s%d',chains(j),resnum(j));
        linker.residue1 = res_tag_i;
        linker.residue2 = res_tag_j;
        linker.type = 'arrow';
        linker_tag = sprintf('Linker_%s%d_%s%d_%s', chains(i),resnum(i),chains(j),resnum(j),linker.type);
        linker.linker_tag = linker_tag

        residue = getappdata( gca, res_tag_i );
        residue.linkers = setdiff( residue.linkers, linker_tag );
        setappdata( gca, res_tag_i, residue );

        residue = getappdata( gca, res_tag_j );
        residue.linkers = setdiff( residue.linkers, linker_tag );
        setappdata( gca, res_tag_j, residue );
        
        if isfield( linker, 'line_handle' ) delete( linker.line_handle ); end;
        if isfield( linker, 'arrow' ) delete( linker.arrow ); end;
        rmappdata( gca, linker_tag );
    end
end
