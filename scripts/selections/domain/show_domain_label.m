function show_domain_label( name, setting )
if ~exist( 'setting', 'var' ) setting = 1; end;

tag = get_domain_tag( name );

if setting; visible = 'on'; else; visible = 'off'; end;

if isappdata( gca, tag )
    domain = getappdata( gca, tag );
    if isfield( domain, 'label' )
        set( domain.label, 'visible', visible );
    end
    domain.label_visible = setting;
    setappdata( gca, tag, domain );
end
    