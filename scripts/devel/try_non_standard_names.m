function try_non_standard_names( sequence, resnum, chains, segid,  non_standard_residues);
% try_non_standard_names( sequence, resnum, chains, non_standard_residues);
%
% Inputs
%  sequence = sequence string 
%  resnum   = residue number (int) associated with each sequence position
%  chains   = chain (char) associated with each sequence position
%  segid    = segment ID (string, possibly blank) with each sequence
%                   position
%  non_standard_residues
%           = structure of index & name, which hold positions in sequence with
%               non-standard residues and their associated names.
%
% (C) R. Das, Stanford University

for i = 1:length(sequence)
    chain = chains(i);
    res   = resnum(i);
    seg   = segid{i};
    res_tag = sprintf('Residue_%s%s%d',chain,seg,res);
    residue = getappdata( gca, res_tag );
    seqpos = intersect( intersect(strfind(chains,chain), find(resnum==res)), ...
        find( strcmp(segid,seg) ) );
    residue.name = upper(sequence(seqpos));
    residue.original_name = sequence(seqpos);
    if ( any( non_standard_residues.index == seqpos ) )
        name = non_standard_residues.name{ find( non_standard_residues.index == seqpos ) };
        residue.non_standard_residue_name = name;
        residue.name = get_preferred_display_name( name );
        if strcmp( 'residue.name', 'X' ) fprintf( 'Warning: displaying X for %s\n', name); end;
    end
    if isfield( residue, 'handle' )  set( residue.handle, 'String', residue.name ); end;
    setappdata( gca, res_tag, residue );
end

