function linker = autotrace_interdomain_linker( linker );
% autotrace_ligand_linker( linker );
if ~exist( 'linker','var') linker = get_tags( 'Linker','interdomain'); end;
autotrace_linker( linker );
