function setup_arrow_linkers(resnum,chains)
% setup_arrow_linkers(resnum,chains)
% draw arrows at dummy locations.

for i = 1:length(resnum)
    j = i + 1;
    if ( j > length( resnum ) ) continue; end;
    if ( chains(j) ~= chains(i) ) continue; end;    
    if ( resnum(j) ~= resnum(i)+1 ) continue; end;    
    res_tag_i = sprintf('Residue_%s%d',chains(i),resnum(i));
    res_tag_j = sprintf('Residue_%s%d',chains(j),resnum(j));
    linker.residue1 = res_tag_i;
    linker.residue2 = res_tag_j;
    linker.type = 'arrow';
    linker_tag = sprintf('Linker_%s%d_%s%d_%s', chains(i),resnum(i),chains(j),resnum(j),linker.type);
    linker.linker_tag = linker_tag;
    % stick this linker information in the connected residues.
    add_linker_to_residue( res_tag_i, linker_tag );
    add_linker_to_residue( res_tag_j, linker_tag );
    if ~isappdata( gca, linker_tag ) setappdata( gca, linker_tag, linker ); end;
end
