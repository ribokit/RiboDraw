function base_pairs = fill_base_normal_orientations( base_pairs );
[keys,orientation] = get_leontis_westhof_table();
for i = 1:length( base_pairs )
    base_pair = base_pairs{i};
    key = [base_pair.edge1,base_pair.edge2,base_pair.LW_orientation];
    base_pair.orientation = orientation{ find(strcmp( keys, key )) };
    base_pairs{i} = base_pair;
end

