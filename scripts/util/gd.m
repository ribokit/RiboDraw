function obj = gd( tag );
% obj = gd( tag );
%
% alias for:
%  getappdata( gca, tag );
% 
% (C) R. Das, Stanford University 2018

if ~exist( 'tag','var')
    obj = [];
    getappdata( gca )
else
    obj = getappdata( gca, tag );
end
