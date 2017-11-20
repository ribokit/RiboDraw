function color = fade_color( color, fade_extent );
% color = fade_color( color );
%
% make color whiter by 70%.
%
% (C) R. Das, Stanford University, 2017
if ~exist( 'fade_extent', 'var') fade_extent = 0.3; end;
color = [1.0,1.0,1.0] - fade_extent * ( [1.0,1.0,1.0] - color );
