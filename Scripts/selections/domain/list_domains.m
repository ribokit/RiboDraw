function list_domains();

tags = get_tags( 'Selection','domain' );
for i = 1:length( tags )
    domain = getappdata( gca, tags{i} );
    fprintf( '%s (%s)\n', domain.name, tags{i} );
end

