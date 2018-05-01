function obj = gd( tag );
% obj = gd( tag );
%
% alias for:
%  getappdata( gca, tag );
% 
% (C) R. Das, Stanford University 2018

obj = getappdata( gca, tag );

