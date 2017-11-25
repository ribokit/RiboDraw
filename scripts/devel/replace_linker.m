function replace_linker( tag, new_tag,  linker );
% Replace linker at tag with new linker object (linker) with new_tag.
% Update any associated residues
% Used only when cleaning up drawings upon format changes, so move to devel/
%
% (C) R. Das, Stanford University

assert( strcmp( linker.linker_tag, new_tag ) )
%if ~strcmp( new_tag, tag )
fix_residue( linker.residue1, tag, new_tag );
fix_residue( linker.residue2, tag, new_tag );
%end
fprintf( 'Replacing %s with %s\n', tag, new_tag );
if isappdata(gca,tag); rmappdata(gca,tag); end;
setappdata( gca, new_tag, linker );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fix_residue( res_tag, tag, new_tag );
residue = getappdata( gca, res_tag );
residue.linkers = setdiff( residue.linkers, tag );
if ~any(strcmp( residue.linkers, new_tag ) ) 
    residue.linkers = [ residue.linkers, new_tag ]; 
end;
setappdata( gca, res_tag, residue );

