function tag = get_domain_tag( name );

tag = sprintf('Selection_%s', strrep(name, ' ', '_' ) );
if ~isappdata( gca, tag );
    tag = name;
    if ~isappdata( gca, tag ) 
        fprintf( 'Could not find domain with name: %s\n', name );
    end
end