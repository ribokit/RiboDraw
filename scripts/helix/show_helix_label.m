function show_helix_label( name, setting )
% show_helix_label( name, setting )
%
% Allows turn on/off of labels, to curate clutter.
% E.g. for replacing 'small helices'
%    with helix groups.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ) setting = 1; end;

tag = get_helix_tag( name );
if length( tag) == 0; return; end;

if setting; visible = 'on'; else; visible = 'off'; end;

if isappdata( gca, tag )
    helix = getappdata( gca, tag );
    if isfield( helix, 'label' )
        set( helix.label, 'visible', visible );
    end
    helix.label_visible = setting;
    setappdata( gca, tag, helix );
end
    