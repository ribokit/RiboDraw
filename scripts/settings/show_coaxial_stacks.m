function show_coaxial_stacks( setting )
% show_coaxial_stacks( setting );
%
% Show or hide labels & graphics for domains.
%  Hiding can give a huge speedup.
%
% (C) R. Das, Stanford University, 2017
if ~exist( 'setting', 'var' ) setting = 1; end;
show_coax_controls( setting );
