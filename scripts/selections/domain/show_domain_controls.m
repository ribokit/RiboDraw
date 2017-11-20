function show_domain_controls( setting )
% 
%   Turn on/off display of boxes around domains that 
%       allow dragging/flipping.
%
% INPUT
% 
%   setting = 0/1 for off/on.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting','var') setting = 1; end;
show_selection_controls( setting, 'Domain' );
if ~exist( 'setting', 'var' ) setting = 1; end;
if ~exist( 'selection_tag', 'var' ) selection_tag = ''; end;