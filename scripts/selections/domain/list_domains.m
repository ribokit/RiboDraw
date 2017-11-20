function list_domains();
% list_domains();
%
% List name and tag in parentheses of all 
%  domains defined by user for drawing.
%
% (C) R. Das, Stanford University, 2017

tags = get_tags( 'Selection','domain' );
for i = 1:length( tags )
    domain = getappdata( gca, tags{i} );
    fprintf( '%s (%s)\n', domain.name, tags{i} );
end

