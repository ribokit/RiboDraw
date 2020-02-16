function tag = sanitize_tag(tag )
% tag = sanitize_tag(tag )
%
% Replace '-' (minus signs) with 'minus' because
% MATLAB can't handle fields with the dash character
%
% (C) R. Das, Stanford University, 2020
tag = strrep( tag, '-', 'minus' );
