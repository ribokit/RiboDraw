function try_non_standard_names( sequence, resnum, chains, non_standard_residues);
% try_non_standard_names( sequence, resnum, chains, non_standard_residues);
%
% Inputs
%  sequence = sequence string 
%  resnum   = residue number (int) associated with each sequence position
%  chains   = chain (char) associated with each sequence position
%  non_standard_residues
%           = structure of index & name, which hold positions in sequence with
%               non-standard residues and their associated names.
%
% (C) R. Das, Stanford University

for i = 1:length(sequence)
    % find which helix is closest to the residue.
    chain = chains(i);
    res   = resnum(i);
    res_tag = sprintf('Residue_%s%d',chain,res);
    residue = getappdata( gca, res_tag );
    seqpos = intersect(strfind(chains,chain), find(resnum==res));
    residue.nucleotide = upper(sequence(seqpos));
    if ( any( non_standard_residues.index == seqpos ) )
        name = non_standard_residues.name{ find( non_standard_residues.index == seqpos ) };
        residue.nucleotide = get_preferred_display_name( name );
        if strcmp( 'residue.nucleotide', 'X' ) fprintf( 'Warning: displaying X for %s\n', name); end;
    end
    if isfield( residue, 'handle' )  set( residue.handle, 'String', residue.nucleotide ); end;
    setappdata( gca, res_tag, residue );
end

