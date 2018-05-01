function list_domains();
% list_domains();
%
% List name and tag in parentheses of all 
%  domains defined by user for drawing.
%
% (C) R. Das, Stanford University, 2017

tags = get_tags( 'Selection','domain' );
for i = 1:length( tags )
    domain = getappdata( gca, tags{i} );
    vis_symbol = ' ';
    if isfield( domain,'label') && strcmp(get(domain.label,'visible'),'on') vis_symbol = '*'; end;
    fprintf( '%s%s (%s)\n', vis_symbol, domain.name, tags{i} );
end


plot_settings = getappdata( gca, 'plot_settings' );
if ~plot_settings.show_domains; 
    fprintf( '\nCurrently domains are not being displayed. Type <a href="matlab: help show_domains">show_domains</a> to display & update domain labels.\n' ); 
else
    fprintf( '\n* = label visible.\n' )
    fprintf( 'Use <a href="matlab: help show_domain_label">show_domain_label</a> and <a href="matlab: help hide_domain_label">hide_domain_label</a> to change label visibility.\n' )
end
