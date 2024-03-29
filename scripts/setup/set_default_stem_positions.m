function stems = set_default_stem_positions( stems )
% stems = set_default_stem_positions( stems )
%
% when starting place helices ('stems') in rows and columns 
%  in a square matrix on figure.
%
% (C) R. Das, Stanford University, 2017

for n = 1:length( stems )
    col = mod( n-1, 5 ) + 1;
    row = floor((n-1)/5);
    stems{n}.center = [col*30, row*20]+20;
    stems{n}.rotation =  180;
    stems{n}.parity   = 1;
    stems{n}.helix_tag = sanitize_tag(sprintf('Helix_%s%s%d',...
        stems{n}.chain1(1),...
        stems{n}.segid1{1},...
        stems{n}.resnum1(1)) );% this better be a unique identifier
    setappdata( gca, stems{n}.helix_tag, stems{n} );
end
