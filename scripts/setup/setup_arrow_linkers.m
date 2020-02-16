function setup_arrow_linkers(resnum,chains,segid)
% setup_arrow_linkers( resnum, chains, segid )
%
% Define arrow linkers connecting contiguous residues. 
%
% See DRAW_LINKER for functions that render the actual graphics.
%
% (C) R. Das, Stanford University, 2017

for i = 1:length(resnum)
    j = i + 1;
    if ( j > length( resnum ) ) continue; end;
    if ( chains(j) ~= chains(i) ) continue; end;    
    if ( resnum(j) ~= resnum(i)+1 ) continue; end;    
    res_tag_i = sanitize_tag(sprintf('Residue_%s%s%d',chains(i),segid{i},resnum(i)));
    res_tag_j = sanitize_tag(sprintf('Residue_%s%s%d',chains(j),segid{j},resnum(j)));
    linker.residue1 = res_tag_i;
    linker.residue2 = res_tag_j;
    linker.type = 'arrow';
    linker_tag = sanitize_tag(sprintf('Linker_%s%s%d_%s%s%d_%s', chains(i),segid{i},resnum(i),chains(j),segid{j},resnum(j),linker.type));
    linker.linker_tag = linker_tag;
    % stick this linker information in the connected residues.
    add_linker_to_residue( res_tag_i, linker_tag );
    add_linker_to_residue( res_tag_j, linker_tag );
    if ~isappdata( gca, linker_tag ) setappdata( gca, linker_tag, linker ); end;
end
