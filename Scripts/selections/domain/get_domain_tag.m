function tag = get_domain_tag( name );

tag = sprintf('Selection_%s_domain', strrep(strrep(name, ' ', '_' ),'-','_') );
if ~isappdata( gca, tag );
    tag = sprintf('Selection_%s',strrep(strrep(name, ' ', '_' ),'-','_') );
end
if ~isappdata( gca, tag );
    [~,tag] = get_res( name ); % look inside domain names.
end
if ~isappdata( gca, tag );
    tag = name;
    if ~isappdata( gca, tag ) 
        fprintf( 'Could not find domain with name: %s\n', name );
    end
end
