function tags = get_tags( headstring, tailstring, objnames )
%  tags = get_tags( headstring )
%  tags = get_tags( headstring, tailstring )
%
% Find all objects in figure with tags like:
%
%  headstring...
%
%  or if tailstring is specified:
%
%  headstring...tailstring
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'objnames','var' )
    vals = getappdata( gca );
    objnames = fields( vals );
end
tags = {};
for n = 1:length( objnames )
    if isempty( strfind( objnames{n}, headstring ) ); continue; end;
    if exist( 'tailstring', 'var' ) 
        if length( objnames{n} ) < length(tailstring ) | ...
                ~strcmp( objnames{n}(end-length(tailstring)+1 : end), tailstring ); continue; end;
    end
    tags = [ tags, objnames{n}];
end
tags = sort( tags );
