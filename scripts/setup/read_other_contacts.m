function other_contacts = read_other_contacts( other_contacts_file )
% other_contacts = read_other_contacts( other_contacts_file )
%
%  Read .other_contacts.txt file output by Rosetta rna_motif executable.
%
%    All pairs of nucleotides that make an atom-atom contact less than 3 Angstroms, after
%       filtering out doublets that are recognized as base pairs and base stacks.
%    Mostly hydrogen bonds involving O2' (2' hydroxyl)  and O1P/O2P (phosphate).
%
% INPUT
%
%  other_contacts_file = text file with lines like
%
%                      A:1  B:20 O2' O2'
%
%                    i.e.,
%
%                      chain1[:segid1]:resnum1 chain2[:segid2]:resnum2  atom1 atom2
%
%                    where atom1 and atom2 denote names  of atoms that come within 3 Angstroms.
%
% OUTPUT
%
%  other_contacts       = cell of struct()s with the same information. 
%
%
% See also: READ_BASE_STACKS, READ_BASE_PAIRS.
% 
% (C) R. Das, Stanford University, 2017

other_contacts = {};
if ~exist( other_contacts_file, 'file' ) return; end;
fid = fopen( other_contacts_file );

while ~feof( fid )
    line = fgetl( fid );
    % C:1347 C:1599 O2' N3 
    cols = strsplit( line, ' ' );
    if length( cols ) >= 4       
        [other_contact.resnum1,other_contact.chain1,other_contact.segid1] = get_one_resnum_from_tag( cols{1} );
        [other_contact.resnum2,other_contact.chain2,other_contact.segid2] = get_one_resnum_from_tag( cols{2} );
        other_contact.atom1 = cols{3};
        other_contact.atom2 = cols{4};
        other_contacts = [other_contacts, other_contact];
    end;
end

