function base_pairs = fill_base_normal_orientations( base_pairs );
% base_pairs = fill_base_normal_orientations( base_pairs );
%
%  looks up anti/para orientation of a base pair based on 
%   the edges involved and cis/trans (Leontis-Westhof style)
%
% Input
%  base_pairs = cell of base pairs with edge1, edge2, LW_orientation fields as characters.
%
% Output
%  base_pairs = same as input but with orientation field ('A','P')
%
% (C) R. Das, Stanford University, 2017.

[keys,orientation] = get_leontis_westhof_table();
for i = 1:length( base_pairs )
    base_pair = base_pairs{i};
    key = [base_pair.edge1,base_pair.edge2,base_pair.LW_orientation];
    base_pair.orientation = orientation{ find(strcmp( keys, key )) };
    base_pairs{i} = base_pair;
end

