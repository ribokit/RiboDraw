function color = fade_color( color );
% color = fade_color( color );
% make color whiter by 70%.
fade_extent = 0.3;
color = [1.0,1.0,1.0] - fade_extent * ( [1.0,1.0,1.0] - color );
