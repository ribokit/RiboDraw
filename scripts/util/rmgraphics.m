function obj = rmgraphics( obj, tags )
% obj = rmgraphics( obj, tags )
%
% Helper function to wipe out graphics in a object.
%
% INPUTS
%   obj = object (like a linker struct)
%   tags = cell of fields correponding to graphics to delete.
%
% (C) R. Das, Stanford, 2018
for i = 1:length( tags )
   tag = tags{i};
   if isfield( obj,tag ) 
       h = getfield(obj,tag);
       if isvalid( h ) delete(h); end;
       obj = rmfield( obj, tag );
   end;
end
