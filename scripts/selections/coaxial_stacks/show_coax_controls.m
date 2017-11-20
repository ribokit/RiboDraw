function show_coax_controls( setting )
% show_coax_controls( setting )
%   Turn on/off display of boxes around coaxial stacks that 
%       allow dragging/flipping.
%   [Off by default]
%
% INPUTS
%    setting       = 0/1 for off/on
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting','var') setting = 1; end;
show_selection_controls( setting, 'coaxial_stack' );
