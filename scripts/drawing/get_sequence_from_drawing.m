function sequence = get_sequence_from_drawing()
% sequence = get_sequence_from_drawing()
% 
%  Output sequence using only letters A, C, G, and U [and X].
%
% (C) R. Das, Stanford University, 2019

res_tags = get_res();
sequence = '';
for i = 1:length( res_tags )
    res = getappdata( gca, res_tags{i} );
    nt = get_preferred_single_letter_name( res.name );    
    sequence = [sequence,nt];
end

 