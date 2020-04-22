function [sequence,resnum] = get_sequence_from_res_tags( res_tags )
% sequence = get_sequence_from_res_tags( res_tags )
% 
%  Output sequence using only letters A, C, G, and U [and X].
%
% (C) R. Das, Stanford University, 2019

sequence = '';
resnum = [];
for i = 1:length( res_tags )
    res = getappdata( gca, res_tags{i} );
    % skip residues whose tag is not present in the drawing
    % (quite possible when generating res_tags from a string)
    if isempty(res)
        continue
    end
    nt = get_preferred_single_letter_name( res.name );    
    sequence = [sequence,nt];
    resnum(i) = res.resnum;
end
