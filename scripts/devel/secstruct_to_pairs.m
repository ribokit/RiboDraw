function pairs = secstruct_to_pairs( secstruct );
%  pairs = secstruct_to_pairs( secstruct );
%
% INPUT:
%  secstruct = secondary structure in dot-bracket notation
% OUTPUT:
%  pairs     = array of integers with length matching secstruct.
%                 0 = unpaired 
%                >0 = pairing partner
%
% (C) R. Das, Stanford University.

bps = ribodraw_convert_structure_to_bps( secstruct );
pairs = zeros( length(secstruct), 1 );
for i = 1:size( bps, 1 ); 
    pairs(bps(i,1)) = bps(i,2); 
    pairs(bps(i,2)) = bps(i,1); 
end;