function show_domain_label( name, setting )
%  show_domain_label( name, setting )
%
%  INPUT
%   name    = string with domain name or actual tag for it in gca
%   setting = 0 or 1 for visible to be 'off' or 'on', respectively.   
%
% (C) R. Das, Stanford University, 2017

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
    