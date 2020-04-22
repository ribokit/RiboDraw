function sequence = get_sequence_from_drawing(res_str)
% sequence = get_sequence_from_drawing(res_tags)
% 
%  Output sequence using only letters A, C, G, and U [and X],
%   based on all res_tags in drawing (default) or specified
%   tags.
%
% (C) R. Das, Stanford University, 2019
% (C) A.Watkins, Stanford University, 2019

if nargin > 0
    res_tags = get_res_tags(res_str, true);
else
    res_tags = get_res_tags()
end
sequence = get_sequence_from_res_tags( res_tags );
