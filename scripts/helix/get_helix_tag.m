function tag = get_helix_tag( name );
% tag = get_helix_tag( name );
%
% Get tag of a helix object in the current drawing (gca)
%   based on its name (or its tag). 
%
% [ Might be deprecated by get_res() ]
%
% (C) Rhiju Das, Stanford University, 2017

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
