function tag = get_domain_tag( name );
% tag = get_domain_tag( name );
%
% Give tag in drawing (gca, current axes of figure) that
%  corresponds to tag or name supplied. 
% Appropriate converts ' ' and '_' to '-'
%
% See also: LIST_DOMAINS() to get possible tags.
%
% (C) R. Das, Stanford University

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
