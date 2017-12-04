function set_nice_axes()
% set_nice_axes()
%
%  Use 'axis image' to automatically set axis limits to have the correct
%   aspect ratio and include all boundary elements. 
%  But then go back to normal axis mode to prevent crazy things from 
%   happening when we drag graphical elements out of bounds.
%  
%
% R. Das, Stanford University, 2017

axis image % tight cropping

%axlim = axis()
pos = plotboxpos;

axis normal

%axis( axlim );
set( gca, 'position', pos );