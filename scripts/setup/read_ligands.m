function ligands = read_ligands( ligand_file );
% base_pairs = read_base_pairs( base_pairs_file )
%
%  Read .ligands.txt file output by Rosetta rna_motif executable, which
%      should include information on which non-RNA chains make contact with RNA.
%
% TODO: rna_motif does not recognize 'ligands' if they have the same chain/segmentID as
%   an RNA chain. Fix that in Rosetta.
%
% INPUT
%
%  ligands_file = text file with lines like
%
%                      C:AB protein  C:QA:1664-1667 C:QA:1669 ...
%
%                    i.e.,
%
%                      ligand_chain[:segid]  ligand_name  RNApartner1_chain:segid:resnum ...
%
% OUTPUT
%
% ligands       = cell of struct()s with the same information.
%
% See also: SETUP_LIGANDS, SETUP_IMAGE_FOR_LIGAND.
% 
% (C) R. Das, Stanford University, 2017

fid = fopen( ligand_file );
ligands = {};
while ~feof( fid )
    line = fgetl( fid );
    % B     protein     R:6 R:8-9 R:11
    if line == -1 ; break ; end
    cols = strsplit( line, ' ' );
    if length( cols ) >= 3 
        clear ligand
        ligand.chain = cols{1}(1);
        ligand.segid = '';
        if length( cols{1} ) > 1 & strcmp( cols{1}(2), ':' )
            ligand.segid = cols{1}(3:end);
        end
        ligand.original_name  = cols{2};
        [resnum,chains,segid] = get_resnum_from_tag( strjoin(cols(3:end)) );
        ligand.ligand_partners = {};
        for i = 1:length( resnum )
            ligand.ligand_partners = [ ligand.ligand_partners, sprintf( 'Residue_%s%s%d',  chains(i), segid{i}, resnum(i) ) ];
        end
        ligands = [ligands,ligand];
    end;
end

