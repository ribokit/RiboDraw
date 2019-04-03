function coords = export_drawing( filename, output_coords )
% coords = export_drawing( filename, output_coords )
%
%  Export drawing to different formats: PostScript, JPEG, PDF, PNG
%
% Inputs:
%  filename      = name of output image (should end in .eps, .jpg, .pdf, or .png)
%  output_coords = [default: 0] Also output tab-separated file with:
%
%                    x y chain segid resnum name
%
%            for each residue/ligand/protein in the drawing.
%            Name will be filename.coords.txt. 
%

%
% See also: SAVE_DRAWING, EXPORT_COORDINATES
%
% (C) R. Das, Stanford University
if ~exist( 'output_coords','var' ) output_coords = 0; end;

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
    case 'svg'
		opt = 'SVG';
    otherwise 
        fprintf( 'Unrecognized extension' )
        help
        return;
end

plot_settings = getappdata( gca, 'plot_settings' );

hide_helix_controls;
hide_domain_controls;
hide_selection_controls;
hide_linker_controls;

tic
if strcmp(opt, 'SVG') == 1
	% Use library function
	plot2svg( filename, gcf );
else
    print( filename, opt, '-r300' );
end
fprintf( 'Created: %s\n', filename ); 
toc

tic
coords = [];
if output_coords
    cdata = imread( filename );
    s = size(cdata);
    coord_filename = [filename, '.coords.txt'];
    coords = export_coordinates( coord_filename, s([2 1]) ); % have to switch x <--> y
end
toc

show_helix_controls ( plot_settings.show_helix_controls );
show_domain_controls( plot_settings.show_domain_controls );
show_coax_controls( plot_settings.show_coax_controls );
show_linker_controls( plot_settings.show_linker_controls );

if system( 'which open' ) == 0; system( ['open ',filename] ); end;

