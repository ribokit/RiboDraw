function v_string = ribodraw_make_tag_with_dashes( v, chain, segid, delimiter );
% v_string = ribodraw_make_tag_with_dashes( v, chain, segid, delimiter );
%
% Takes, e.g., [ 2 3 4 279 280 281] and gives compact string  '2-4 279-281'
%
% Inputs:
%  v = Vector of integers
%  chain = [optional] Character for chain. If multiple chains, give string of characters with
%               same length as v. (Default: ' ', no chain )
%  segid = [optional] 4-letter string for segid. If multiple segids, give array of strings with
%               same length as v. (Default: '', no segid)
%  delimiter = [optional] delimiter between ranges (default is space)
%
% Output:
%  v_string = nice string with continuous ranges with dashes
%
% (C) R. Das, Stanford University, 2013, 2020

if ~exist( 'chain', 'var' ) chain = ' '; end;
if ~exist( 'segid', 'var' ) segid = ''; end;
if ~exist( 'delimiter','var') delimiter = ' '; end;
if ischar(chain) & length( chain ) == 1; chain = repmat( chain, 1, length(v) ); end
if ischar( segid ); segid = repmat( {segid}, 1, length(v) ); end
assert( length( chain ) == length( v ) );
assert( length( segid ) == length( v ) );

v_string = '';

v_range = [ v(1) ];
chain_range = chain(1);
segid_range = segid{1};
for i = 2:length(v)
  if v(i) == v_range(end)+1 & chain(i) == chain_range & strcmp(segid{i},segid_range)
    v_range = [ v_range, v(i) ];
  else
    v_string = add_to_v_string( v_string, v_range, chain_range, segid_range, delimiter );
    v_range = [ v(i) ];
    chain_range = chain(i);
    segid_range = segid{i};
  end
end
v_string = add_to_v_string( v_string, v_range, chain_range, segid_range, delimiter );


%%%%%%%%%%%%%%%%%%%%
function  v_string = add_to_v_string( v_string, v_range, chain_range, segid_range, delimiter );
v_range_string = num2str(v_range(1));
if length( v_range ) > 1; v_range_string = [v_range_string, '-', num2str(v_range(end)) ]; end;

if length(segid_range)>0 
    v_range_string = [segid_range,':',v_range_string];
end
if length(chain_range)>0 & ( ~strcmp(chain_range, ' ' ) | length( segid_range > 0 ) )
    v_range_string = [chain_range,':',v_range_string];
end

if length( v_string ) == 0; v_string = v_range_string;
else v_string = [ v_string,delimiter,v_range_string];end

