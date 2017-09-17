function tags = get_tags( headstring, tailstring )
vals = getappdata( gca );
objnames = fields( vals );
tags = {};
for n = 1:length( objnames )
    if isempty( strfind( objnames{n}, headstring ) ); continue; end;
    if exist( 'tailstring', 'var' ) & isempty( strfind( objnames{n}, tailstring ) ); continue; end;
    tags = [ tags, objnames{n}];
end
tags = sort( tags );
