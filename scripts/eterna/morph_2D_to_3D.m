function morph_2D_to_3D( coords2D, coords3D, resname, outdir );
%  morph_2D_to_3D( coords2D, coords3D, resname );
%
% Pilot animation of 2D Eterna-like representation  
%  to 3D Eterna-like representation.
%
% INPUTS
%   coords2D = [N x 2] coordinates from, e.g., RiboDraw  (see GET_COORDS2D)
%   coords3D = [N x 3] coordinates from PDF file (see GET_COORDS3D)
%   resname  = string of N residue names ('A','C','G','U');
%   outdir   = [optional] out directory to save PNG's of frames...
%                     *not recommended*. Instead, run the animation and
%                     use your system's screen capture tool to get the movie.
%
% (C) R. Das, Stanford University, 2019

figure(3); clf;
set(gcf, 'PaperPositionMode','auto','color','white');
set_bg_color( [16,33,59]/255 );

assert( length( coords2D ) == length( coords3D ) );

% Draw connecting line. I guess this could/should be smoothly interpolated 
% like base rope.
h1 = plot3( coords3D(:,1),coords3D(:,2),coords3D(:,3),'-','linew',10,'color',[[1,1,1]*0.7, 0.3]); 
hold on
h2 = plot3( coords3D(:,1),coords3D(:,2),coords3D(:,3),'-','linew',4,'color',[[1,1,1]*0.9, 0.3]); 
if length( coords3D) > 100; 
    set( h1,'linew',4 ); 
    set( h2,'linew',3 ); 
end;

% Draw circles at bases, with appropriate Eterna coloring
% Maybe should be spheres.
if length( coords3D ) < 1000
    for i = 1:length( coords3D );
        hp(i) = plot3( coords3D(:,1),coords3D(:,2),coords3D(:,3),'o','color','white','markersize',12);
        set(hp(i),'markerfacecolor',get_eterna_color(get_preferred_single_letter_name(get_preferred_display_name( resname{i}) )));
        if length( coords3D) > 100; set( hp(i),'color','none','markersize',4 ); end;
    end
end

axis off
axis equal
axis vis3d


if exist( 'outdir','var' )
    if ~exist( outdir, 'dir' ); mkdir( outdir ); end;
    delete( [outdir,'/*'] );
end

%set(gca,'CameraPosition',[0 0 308.2836]) % overhead view.

% Animate!
fprintf( '\n\nHit Ctrl-C to stop!!\n\n' );
coords2D(:,3) = 0.0; % start 2D coordinates in x,y plane.
count = 0;
frames = [ zeros(1,40), 0:100, 100*ones(1,40), 100:-1:0];
for i = repmat(frames,1,100)
    % rotate camera when RNA is in pure 2D or 3D state.
    if ( i == 100 ); camorbit( 2,0); end;        
    if ( i ==   0 ); camorbit(-2,0); end;        

    prog = i/100;
    v = coords3D - coords2D;
    coords = coords2D + (v + v*prog)/2 * prog;
    set(h1,'XData',coords(:,1),'YData',coords(:,2),'ZData',coords(:,3));
    set(h2,'XData',coords(:,1),'YData',coords(:,2),'ZData',coords(:,3));
    if length( coords3D ) < 1000
        for n = 1:length( coords3D );
            set(hp(n),'XData',coords(n,1),'YData',coords(n,2),'ZData',coords(n,3));
        end
    end
    drawnow;
    if exist( 'outdir','var' )
        imname = sprintf('%s/mov%03d.png',outdir,count);
        fprintf( 'Creating %s... (%d of %d) \n', imname,count+1,length(frames))
        export_fig( imname,'-nocrop','-r150' )
        count = count+1;
    end
end
