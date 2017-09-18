function idx = find_in_doublets( base_pairs, base_pair );
idx = 0;
for i = 1:length( base_pairs )
    if isequal( base_pairs{i}, base_pair ) idx = i; break; end;
end
