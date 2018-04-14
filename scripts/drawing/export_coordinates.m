function plot_pos = export_coordinates( filename );
% plot_pos = export_coordinates( filename );
%
% filename = name of tab-separated file with:
%
%                    x y chain segid resnum name
%
%            for each residue/ligand/protein in the drawing.
%
% (C) R. Das, Stanford University, 2018

if nargin < 1; help( mfilename ); return; end;

res_tags = get_tags('Residue');
xl = get( gca,'xlim' );
yl = get(gca,'ylim');
fid = fopen( filename,'w' );
for i = 1:length( res_tags )
    res = getappdata( gca, res_tags{i} );
    x = res.plot_pos(1) - xl(1);
    y = yl(2) - res.plot_pos(2); % reverse MATLAB's y-axis since every other program does that.
    outstring = sprintf( '%7.3f\t%7.3f\t%s\t%s\t%d\t%s\n',res.plot_pos(1),res.plot_pos(2),res.chain,res.segid,res.resnum,strrep(res.nucleotide,'\','\\'));
    fprintf( outstring );
    fprintf( fid, outstring );
    plot_pos(i,:) = [x,y];
end

fprintf('\nOutputted %d coordinates to %s.\n', length(res_tags), filename );
fclose( fid );
