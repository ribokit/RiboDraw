function set_helix_visibility( helix, visible )
% set_helix_visibility( helix, visible )
% Helper function
% (C) R. Das, Stanford University, 2018
if ~ischar( visible );
    setting = visible;
    if setting; visible = 'on'; else; visible = 'off'; end;
end

if isfield( helix, 'click_center' )   set( helix.click_center,'visible', visible); end;
if isfield( helix, 'reflect_line' )   set( helix.reflect_line, 'visible', visible); end;
if isfield( helix, 'reflect_line1' )   set( helix.reflect_line1, 'visible', visible); end;
if isfield( helix, 'reflect_line2' )   set( helix.reflect_line2, 'visible', visible); end;
if isfield( helix, 'rectangle' )      set( helix.rectangle, 'visible', visible); end;
