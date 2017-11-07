function bounds = get_patch_from_image( image_file, show_drawing );
% a hack from plot_2d (rhiju's attempts to auto-solve jigsaw puzzles)
%
% (C) R. Das, Stanford University

if ~exist( 'show_drawing', 'var' ) show_drawing = 1; end;
THRESHOLD = 50;

image_x = imread( image_file ); 

image_mean = mean( image_x, 3 );

for i = 1:3  
  image_y(:,:,i) = max( double( image_x(:,:,i) ) - image_mean, 0);    
end

image_y = max( 2*image_y, 0 );
image_binary = ( sum(image_y,3) > THRESHOLD );


[b,l,n] = bwboundaries( image_binary );
bounds = b{1};

[xg,yg] = meshgrid( 1:size(image_binary,1), 1:size(image_binary,2 ) );
ctr = [ sum(xg(:).*image_binary(:)) / sum(image_binary(:)),...
        sum(yg(:).*image_binary(:)) / sum(image_binary(:)) ];
ctr = centerOfMass( uint8(image_binary) );

if show_drawing; 
    image( image_x ); 
    hold on; 
    plot( bounds(:,2), bounds(:,1),'linew',2,'color','r' );
plot( ctr(2), ctr(1),'x' )
hold off
end

bounds = bounds - repmat( ctr, size( bounds,1), 1 );
bounds = bounds(:,end:-1:1);      % in ribodraw, x<->y is normal.
bounds(:,2) = -bounds(:,2); % need to flip y axis.