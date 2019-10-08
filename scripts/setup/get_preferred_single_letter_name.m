function nt = get_preferred_single_letter_name( name )
% nt = get_preferred_single_letter_name( name )
%
% INPUT
%  name = name in FASTA file, e.g., 2MA or D.
%
% OUTPUT
%  nt = display name for nucleotide, e.g., A.
%
% (C) R. Das, Stanford University, 2019
nt = name;
switch name
    case 'D'
        nt = 'U';
    case '\psi'
        nt = 'U';
    case 'yW'
        nt = 'G';
    case 'm^3\psi'
        nt = 'U';
end

nts = 'ACGU';
% Look for A,C,G, U in name, e.g., 'Am' --> 'A' 
if length( nt ) > 1
    for i = 1:length(nts)
        if ~isempty( strfind( nt, nts(i) ) )
            nt = nts(i);
            break
        end
    end
end

for i = 1:length(nts)
    if strcmp( nt, nts(i) )
        return;
    end
end

fprintf( 'Could not recognize %s, replacing with X\n', nt );
nt = 'X';





