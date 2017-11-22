function show_extra_arrows( setting )
% show_extra_arrows( setting )
%
% Show or hide arrows on all long line segments of the lines that connect
%   a residue to the next residue in the sequence, based on whether setting is 1 or 0.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ) setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_extra_arrows = setting;
setappdata( gca, 'plot_settings', plot_settings );

draw_linker( get_tags('Linker','arrow') );
