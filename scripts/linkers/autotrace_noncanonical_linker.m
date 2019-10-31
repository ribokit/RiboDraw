function linker = autotrace_noncanonical_pair_linker( linker );
% autotrace_noncanonical_pair_linker();
if ~exist( 'linker','var') linker = get_tags( 'Linker','noncanonical_pair'); end;
autotrace_linker( linker );
