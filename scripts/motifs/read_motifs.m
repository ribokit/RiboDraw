function motifs = read_motifs( motif_file );
%  motifs = read_motifs( motif_file );
%
% read text file with Rosetta rna_motif output format. Lines are like:
%
% U_TURN A:33-35
% U_TURN A:55-57
% UA_HANDLE A:53-54 A:58 A:61
% T_LOOP A:53-58 A:61
% INTERCALATED_T_LOOP A:53-58 A:61 A:18
%
%  INPUT
%   motifs_file = text file with Rosetta rna_motif output.
%
% (C) R. Das, Stanford University, 2019

fid = fopen( motif_file );
motifs = {};
while ~feof( fid )
    line = fgetl( fid );
    % UA_HANDLE A:53-54 A:58 A:61
    if line == -1 ; break ; end
    cols = strsplit( line, ' ' );
    if length( cols ) >= 2 
        clear motif

        motif.motif_type = cols{1};
        [resnum,chains,segid] = get_resnum_from_tag( strjoin(cols(2:end)) );
        motif.associated_residues = {};
        for i = 1:length( resnum )
            motif.associated_residues = [ motif.associated_residues, sprintf( 'Residue_%s%s%d',  chains(i), segid{i}, resnum(i) ) ];            
        end
        assert( length( motif.associated_residues ) > 1 );
        motif.motif_tag = sprintf( 'Motif_%s_%s', motif.motif_type, strrep(motif.associated_residues{1},'Residue_','') );
        motifs = [motifs,motif];
    end;
end




