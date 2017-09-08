function draw_dummy_linkers()
% draw_dummy_linkers()
% draw arrows at dummy locations.

sequence = getappdata( gca, 'sequence' );
resnum   = getappdata( gca, 'resnum' );
chains   = getappdata( gca, 'chains' );

for i = 1:length(sequence)
    j = i + 1;
    if ( j > length( sequence ) ) continue; end;
    if ( chains(j) ~= chains(i) ) continue; end;    
    res_tag_i = sprintf('Residue_%s%d',chains(i),resnum(i));
    res_tag_j = sprintf('Residue_%s%d',chains(j),resnum(j));
    linker.residue1 = res_tag_i;
    linker.residue2 = res_tag_j;
    linker.type = 'arrow';
    linker.line_handle = plot( [0,0],[0,0],'k','linewidth',1.2 ); % dummy for now -- will get redrawn later.
    linker.arrow = patch( [0,0,0],[0,0,0],'k' );
    % stick this linker information in the connected residues.
    add_linker_to_residue( res_tag_i, linker );
    add_linker_to_residue( res_tag_j, linker );
    residue = getappdata( gca, res_tag_j ); residue.linkers = [ residue.linkers, linker ]; setappdata( gca, res_tag_j, residue );
end
