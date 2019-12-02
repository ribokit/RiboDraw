function sequence = get_sequence_from_drawing()
% sequence = get_sequence_from_drawing()
% 
%  Output sequence using only letters A, C, G, and U [and X],
%   based on all res_tags in drawing.
%
% (C) R. Das, Stanford University, 2019

res_tags = get_res();
sequence = get_sequence_from_res_tags( res_tags );
