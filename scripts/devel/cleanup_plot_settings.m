function cleanup_plot_settings()
%  cleanup_plot_settings()
%
% (C) Rhiju Das, Stanford University, 2018

plot_settings = getappdata( gca, 'plot_settings' );
if isfield( plot_settings, 'show_interdomain_noncanonical_pairs'  )
    if ~isfield( plot_settings, 'show_tertiary_noncanonical_pairs' )
        plot_settings.show_tertiary_noncanonical_pairs = plot_settings.show_interdomain_noncanonical_pairs;
    end
    plot_settings = rmfield( plot_settings, 'show_interdomain_noncanonical_pairs' );
    setappdata( gca, 'plot_settings', plot_settings );
end
if ~isfield( plot_settings, 'show_domains' )
    plot_settings.show_domains = 0;
    setappdata( gca, 'plot_settings', plot_settings );
end

if ~isfield( plot_settings, 'tick_frequency' )
    % old tacit default
    plot_settings.tick_frequency = 10;
    setappdata( gca, 'plot_settings', plot_settings );
end
