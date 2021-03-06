function bounds = get_patch_from_image( image_file, show_drawing );
%
% A hack from plot_2d (rhiju's attempts to auto-solve jigsaw puzzles)
%
%
% TODO: set thresholding to work on any image output from Pymol.
%
% Inputs:
%  image_file   = .png or .jpg file with a picture of the ligand, e.g. a ray-traced picture from Pymol.
%  show_drawing = 0 or 1 to draw the image and boundary in a new MATLAB figure. [default is 1] 
%
% Output:
%  bounds = N x 2 path of the boundary of the image, which allows drawing of silhouette patches when
%            installed into a ligand's image_boundary field.
%
% (C) R. Das, Stanford University

if ~exist( 'show_drawing', 'var' ) show_drawing = 1; end;
THRESHOLD = 5;

image_x = imread( image_file ); 

if show_drawing; 
    figure();
    image( image_x ); 
    hold on; 
end
image_mean = mean( image_x, 3 );

% color contrast.
%for i = 1:3  
%  image_y(:,:,i) = max( double( image_x(:,:,i) ) - image_mean, 0);    
%end
%image_y = max( 2*image_y, 0 );
image_y = 256 - image_x;
THRESHOLD = min( THRESHOLD, max( image_y(:)/10 ) );
image_binary = ( sum(image_y,3) > THRESHOLD );

[b,l,n] = bwboundaries( image_binary );

% find longest boundary
numpts = [];
for i = 1:length(b)
    numpts(i) = size(b{i},1);
end
[~,idx] = max( numpts );
bounds = b{idx};

ctr = centerOfMass( uint8(image_binary) );

if show_drawing
    plot( bounds(:,2), bounds(:,1),'linew',2,'color','r' );
    plot( ctr(2), ctr(1),'x' )
    hold off
end

bounds = bounds - repmat( ctr, size( bounds,1), 1 );
bounds = bounds(:,end:-1:1);      % in ribodraw, x<->y is normal.
bounds(:,2) = -bounds(:,2); % need to flip y axis.