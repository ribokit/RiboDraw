function v_string = ribodraw_make_tag_with_dashes( v, delimiter );
% v_string = ribodraw_make_tag_with_dashes( v, delimiter );
%
% Takes, e.g., [ 2 3 4 279 280 281] and gives compact string  '2-4 279-281'
%
% Inputs:
%  v = Vector of integers
%  delimiter = [optional] delimiter between ranges (default is space)
%
% Output:
%  v_string = nice string with continuous ranges with dashes
%
% (C) R. Das, Stanford University, 2013

if ~exist( 'delimiter','var') delimiter = ' '; end;

v_string = '';
v_range = v(1);
for i = 2:length(v)
  if v(i) == v_range(end)+1
    v_range = [ v_range, v(i) ];
  else
    v_string = add_to_v_string( v_string, v_range, delimiter );
    v_range = [ v(i) ];
  end
end
v_string = add_to_v_string( v_string, v_range, delimiter );


%%%%%%%%%%%%%%%%%%%%
function    v_string = add_to_v_string( v_string, v_range, delimiter );
v_range_string = num2str(v_range(1));
if length( v_range ) > 1; v_range_string = [v_range_string, '-', num2str(v_range(end)) ]; end;
if length( v_string ) == 0; v_string = v_range_string;
else v_string = [ v_string,delimiter,v_range_string];end
