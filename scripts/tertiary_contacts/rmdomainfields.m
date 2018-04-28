function linker = rmdomainfields( linker );
% linker = rmdomainfields( linker );
%
% helper function that removes domain1, domain2, and interdomain fields
%  from a linker.
%
% NOTE: this actually updates linker in GCA.
%
% (C) R. Das, Stanford University 2018

% most of the following is actually deprecated...
if isfield( linker, 'domain1' ) linker = rmfield( linker, 'domain1'); end
if isfield( linker, 'domain2' ) linker = rmfield( linker, 'domain2'); end
if isfield( linker, 'interdomain' ) linker = rmfield( linker, 'interdomain'); end
if isfield( linker, 'grouped_into_tertiary_contact' ) linker = rmfield( linker, 'grouped_into_tertiary_contact'); end
if isfield( linker, 'tertiary_contact' ) linker = rmfield( linker, 'tertiary_contact'); end
setappdata( gca, linker.linker_tag, linker );

