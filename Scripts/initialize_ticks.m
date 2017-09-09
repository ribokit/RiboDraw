function initialize_ticks()

sequence = getappdata( gca, 'sequence' );
resnum   = getappdata( gca, 'resnum' );
chains   = getappdata( gca, 'chains' );
tickres = find( mod( resnum, 10 ) == 0 );
for i = tickres   
    res_tag = sprintf('Residue_%s%d',chains(i),resnum(i));
    residue = getappdata( gca, res_tag );
    if ~isfield( residue, 'tickrot' ) residue.tickrot = nan; end; % nan means set later based on how helix is rotated.
    setappdata( gca, res_tag, residue );
end
