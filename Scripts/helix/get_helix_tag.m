function tag = get_helix_tag( name );

tag = '';

tags = get_tags( 'Helix' );
for i = 1:length( tags )
    if strcmp(tags{i},name)
        tag = tags{i}; break;
    else
        helix = getappdata( gca, tags{i} );
        if strcmp( helix.name, name )
            tag = tags{i}; break;
        end
    end
end

if length( tag ) == 0;
    fprintf( 'Could not find helix with name: %s\n', name );
end
