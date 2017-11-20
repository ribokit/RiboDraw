function show_selection_controls( setting, selection_tag )
% show_selection_controls( setting, selection_tag )
%
%   Turn on/off display of boxes around domains that 
%       allow dragging/flipping.
%
% INPUTS
%    setting       = 0/1 for off/on
%    selection_tag = 'Domain' / 'coaxial'
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ) setting = 1; end;
if ~exist( 'selection_tag', 'var' ) selection_tag = ''; end;

plot_settings = getappdata( gca, 'plot_settings' );

tags= {};
if strcmp( selection_tag, 'Domain' )
    % following could probably be replaced with 'get_domain_tag'
    plot_settings.show_domain_controls = setting;
    setappdata( gca, 'plot_settings', plot_settings );
    selection_tags = get_tags( 'Selection_');
    tags = {};
    for i = 1:length(selection_tags);
        selection = getappdata( gca, selection_tags{i});
        if strcmp( selection.type, 'domain' ) tags = [tags, selection_tags{i} ]; end;
    end    
elseif strcmp( selection_tag, 'coaxial_stack' )
    % coaxial may be deprecated in future.
    plot_settings.show_coax_controls = setting;
    setappdata( gca, 'plot_settings', plot_settings );
    tags = get_tags( 'Selection_', selection_tag );
end

if ( setting == 1 )
    draw_selections( tags );
end

% hide all blue stuff that was used for interactive movement.
if setting; visible = 'on'; else; visible = 'off'; end;
for n = 1:length(tags)
    selection = getappdata( gca, tags{n} );
    set_visibility( selection, {'rectangle','auto_text','click_center','reflect_line_horizontal1','reflect_line_horizontal2','reflect_line_vertical1','reflect_line_vertical2'}, visible );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_visibility( selection, handle_names, visible );
for i = 1:length( handle_names )
    handle_name = handle_names{i};
    if isfield( selection, handle_name ); 
        handle = getfield( selection, handle_name );
        set( handle ,'visible', visible); 
    end;
end
