function show_domain_label( name, setting )
if ~exist( 'setting', 'var' ) setting = 1; end;

tag = sprintf('Selection_%s', strrep(name, ' ', '_' ) );
if ~isappdata( gca, tag );
    tag = name;
    if ~isappdata( gca, tag ) 
        fprintf( 'Could not find domain with name: %s\n', name );
    end
end

if setting; visible = 'on'; else; visible = 'off'; end;

if isappdata( gca, tag )
    domain = getappdata( gca, tag );
    if isfield( domain, 'label' )
        set( domain.label, 'visible', visible );
    end
    domain.label_visible = setting;
    setappdata( gca, tag, domain );
end
    