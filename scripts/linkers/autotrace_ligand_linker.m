function linker = autotrace_ligand_linker( linker );
% autotrace_ligand_linker( linker );
if ~exist( 'linker','var') linker = get_tags( 'Linker','ligand'); end;
autotrace_linker( linker );
