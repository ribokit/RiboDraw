function show_domains( setting )
% show_domains( setting );
%
% Show or hide labels & graphics for domains.
%  Hiding can give a huge speedup.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ); setting = 1; end;

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.show_domains = setting;
setappdata( gca, 'plot_settings', plot_settings );
draw_selections();
