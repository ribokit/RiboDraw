function fix_original_names( fasta_file )
%
% In v0.70 drawings and later, we save information on original sequence
% letters and any non_standard_names in  Residues. These should come from the
% FASTA.
%
% This helper function allows that information to be rediscovered from a
% fasta_file after a legacy drawing has been read in.
%
[sequence,resnum,chains,segid,non_standard_residues] = get_sequence( fasta_file );
try_non_standard_names( sequence, resnum, chains, segid, non_standard_residues);
