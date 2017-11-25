function export_drawing( filename )
% export_drawing( filename )
%
%  Export drawing to different formats: PostScript, JPEG, PDF, PNG
%
% Inputs:
%  filename = name of output image (should end in .eps, .jpg, .pdf, or .png)
%
% See also: SAVE_DRAWING
%
% (C) R. Das, Stanford University

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
	case: 'svg'
		opt = '';
    otherwise 
        fprintf( 'Unrecognized extension' )
        help
        return;
end

plot_settings = getappdata( gca, 'plot_settings' );

hide_helix_controls;
hide_selection_controls;
hide_linker_controls;

if opt = ''
	print( filename, opt );
else
	% Use library function
	plot2svg( 'myfile.svg', gcf );
end
fprintf( 'Created: %s\n', filename ); 

show_helix_controls ( plot_settings.show_helix_controls );
show_domain_controls( plot_settings.show_domain_controls );
show_coax_controls( plot_settings.show_coax_controls );
show_linker_controls( plot_settings.show_linker_controls );

