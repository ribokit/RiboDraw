function add_linker_to_residue( res_tag, linker_tag )
% add_linker_to_residue( res_tag, linker )
%
% util function for associating linker information to residues.
%
% Inputs:
%  res_tag    = (string) tag of residue in drawing (gca)
%  linker_tag = (string) tag of linker in drawing (gca)
%
% (C) R. Das, Stanford University, 2017
residue = getappdata( gca, res_tag );
if ~isfield( residue, 'linkers' ) residue.linkers = {}; end;
if ~any( strcmp( residue.linkers, linker_tag ) )
    residue.linkers = [ residue.linkers, linker_tag ];
    setappdata( gca, res_tag, residue );
end