function color = fade_color( color, fade_extent );
% color = fade_color( color );
%
% make color whiter 
%
% INPUTS
%    color = input_color
%    fade_extent = amount by which to fade (default is 70%).
%
% (C) R. Das, Stanford University, 2017-2018
if ~exist( 'fade_extent', 'var') fade_extent = 0.7; end;
color = fade_extent * [1.0,1.0,1.0] + ( 1 - fade_extent ) * color;
