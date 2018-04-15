function coords = export_coordinates( filename, image_size );
% coords = export_coordinates( filename, image_size );
%
% Helper function -- better to use EXPORT_DRAWING!
%
% filename = name of tab-separated file with:
%
%                    x y chain segid resnum name
%
%            for each residue/ligand/protein in the drawing.
% image_size = size of output image in pixels [default: look at xlim & ylim in axis]
%  
%
% See also EXPORT_DRAWING.
%
% (C) R. Das, Stanford University, 2018

if nargin < 1; help( mfilename ); return; end;

res_tags = get_tags('Residue');
xl = get( gca,'xlim' );
yl = get(gca,'ylim');
if ~exist( 'image_size','var')
    image_size = [ xl(2)-xl(1), yl(2) - yl(1) ];
end
axis_size = [ xl(2)-xl(1), yl(2) - yl(1) ];
sf1 = image_size(1)/axis_size(1);
sf2 = image_size(2)/axis_size(2);
    
fid = fopen( filename,'w' );
coords = [];
for i = 1:length( res_tags )
    res = getappdata( gca, res_tags{i} );
    x = sf1 * ( res.plot_pos(1) - xl(1) );
    y = sf2 * ( yl(2) - res.plot_pos(2) ); % reverse MATLAB's y-axis since every other program does that.
    outstring = sprintf( '%7.3f\t%7.3f\t%s\t%s\t%d\t%s\n',x,y,res.chain,res.segid,res.resnum,strrep(res.nucleotide,'\','\\'));
    %fprintf( outstring );
    fprintf( fid, outstring );
    coords(i,:) = [x,y];
end

fprintf('\nOutputted %d coordinates to %s.\n', length(res_tags), filename );
fclose( fid );
