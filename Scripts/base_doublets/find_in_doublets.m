function idx = find_in_doublets( base_pairs, base_pair );
% idx = find_in_doublets( base_pairs, base_pair );
%
% helper function to find index idx of a base_pair in a cell of base_pairs.
%
% (C) R. Das, Stanford University, 2017.
idx = 0;
for i = 1:length( base_pairs )
    if isequal( base_pairs{i}, base_pair ) idx = i; return; end;
end
