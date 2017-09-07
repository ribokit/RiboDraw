function add_linker_to_residue( res_tag, linker )
% add_linker_to_residue( res_tag, linker )
% util function for associating linker information to residues.
% (C) R. Das, Stanford University, 2017
residue = getappdata( gca, res_tag );
if ~isfield( residue, 'linkers' ) residue.linkers = {}; end;
residue.linkers = [ residue.linkers, linker ]; 
setappdata( gca, res_tag, residue );
