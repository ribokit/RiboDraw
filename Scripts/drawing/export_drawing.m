function export_drawing( filename )

cols = strsplit( filename, '.' );
switch cols{end}
    case {'eps','ps','ai'}
        opt = '-depsc2';
    case 'pdf'
        opt = '-dpdf';
    case 'jpg','jpeg'
        opt = '-djpg';
    case 'png'
        opt = '-dpng';
    otherwise 
        fprintf( 'Unrecognized extension' )
        help
        return;
end

plot_settings = getappdata( gca, 'plot_settings' );

hide_helix_controls;
hide_domain_controls;
hide_linker_controls;

print( filename, opt );
fprintf( 'Created: %s\n', filename ); 

show_helix_controls ( plot_settings.show_helix_controls );
show_domain_controls( plot_settings.show_domain_controls );
show_linker_controls( plot_settings.show_linker_controls );

