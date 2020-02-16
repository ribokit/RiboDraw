function [sequence,resnum,chains,segid,non_standard_residues] = get_sequence( fasta_file )
% [sequence,resnum,chains,segid, non_standard_residues] = get_sequence( fasta_file )
%
%   or if no fasta_file specified, get_sequence_from_drawing()
%
% read sequence from FASTA file ? and figure out chain/numbering from tags
% like "A:4-89" in header. Allow sequence to include "Z[1MA]" to define 
% non-standard residues, like in Rosetta.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'fasta_file' )
    sequence = get_sequence_from_drawing();
    return;
end

fasta = fastaread( fasta_file );
 fasta.Header 
[resnum,chains,segid] = get_resnum_from_tag( fasta.Header );

raw_sequence = fasta.Sequence;

sequence = '';
non_standard_residues.index = [];
non_standard_residues.name  = {};
i = 1;
while (i <= length(raw_sequence) )
    sequence = [sequence, raw_sequence(i) ];
    if i < length( raw_sequence ) & strcmp(raw_sequence(i+1),'[')
        non_standard_name = '';
        i = i+2;
        while ( i <= length( raw_sequence ) & ~strcmp(raw_sequence(i),']' ) )
            non_standard_name = [non_standard_name, raw_sequence(i)];
            i = i+1;
        end
        non_standard_residues.index = [non_standard_residues.index,length(sequence)];
        non_standard_residues.name  = [non_standard_residues.name,non_standard_name];
    end
    i = i+1;
end

if length( chains ) == 0
    chains = repmat( ' ', [1 length(sequence)] );
    segid = repmat( {''}, [1 length(sequence)] );
    resnum = [1:length(sequence)];
end

assert( length( chains ) == length( resnum ) );
assert( length( chains ) == length( sequence ) );
assert( length( chains ) == length( segid ) );

