function stem_assignment = figure_out_stem_assignment( secstruct )
%
% INPUT
%  secstruct = secondary structure in dot-parens notation
%
% OUTPUT
% stem_assignment = 1XN array, 0 for non-pairs; 1,2,... index for each
%          stem.
if ischar( secstruct )
    bps = ribodraw_convert_structure_to_bps( secstruct );
else % assume partner vector is given
    partner = secstruct;
    bps = [];
    for i = 1:length( partner )
        if partner(i) > i
            bps = [bps; i, partner(i) ];
        end
    end
end

stems = ribodraw_parse_stems_from_bps( bps );

stem_assignment = zeros(1,length(secstruct));
for i = 1:length( stems )
    stem = stems{i};
    for j = 1:size( stem, 1 )
        stem_assignment( stem(j,1) ) = i;
        stem_assignment( stem(j,2) ) = i;
    end    
end    
