sequence = getappdata( gca, 'sequence' );
resnum   = getappdata( gca, 'resnum' );
chains   = getappdata( gca, 'chains' );
non_standard_residues = getappdata( gca, 'non_standard_residues' );
for i = 1:length(sequence)
    % find which helix is closest to the residue.
    chain = chains(i);
    res   = resnum(i);
    res_tag = sprintf('Residue_%s%d',chain,res);
    residue = getappdata( gca, res_tag );
    seqpos = intersect(strfind(chains,chain), find(resnum==res));
    residue.nucleotide = upper(sequence(seqpos));
    if ( any( non_standard_residues.index == seqpos ) )
        residue.nucleotide = get_preferred_display_name( non_standard_residues.name{ find( non_standard_residues.index == seqpos ) } );
    end
    setappdata( gca, res_tag, residue );
end

