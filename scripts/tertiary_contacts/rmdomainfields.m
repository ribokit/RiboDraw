function linker = rmdomainfields( linker );
% linker = rmdomainfields( linker );
%
% helper function that removes domain1, domain2, and interdomain fields
%  from a linker.
%
% NOTE: this actually updates linker in GCA.
%
% (C) R. Das, Stanford University 2018

if isfield( linker, 'domain1' ) linker = rmfield( linker, 'domain1'); end
if isfield( linker, 'domain2' ) linker = rmfield( linker, 'domain2'); end
if isfield( linker, 'interdomain' ) linker = rmfield( linker, 'interdomain'); end
setappdata( gca, linker.linker_tag, linker );

