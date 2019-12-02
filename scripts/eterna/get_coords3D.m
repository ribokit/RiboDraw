function [coords3D,resName,resSeq] = get_coords3D( pdbfile );
% [coords3D,resName,resSeq] = get_coords3D( pdbfile );
%
% TODO: handle chains correctly. 
%

x = pdbread( pdbfile );
coords3D = [];resName = {}; resSeq=[];
[coords3D, resName, resSeq] = get_coords( x.Model.Atom, coords3D, resName, resSeq );
[coords3D, resName, resSeq] = get_coords( x.Model.HeterogenAtom, coords3D, resName, resSeq );

[~,idx] = sort( resSeq ); % won't work if multiple chains!
coords3D = coords3D(idx,:);
resName = resName(idx);
resSeq = resSeq(idx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [coords3D, resName, resSeq] = get_coords( atoms, coords3D, resName, resSeq );
for i = 1:length( atoms )
    atom = atoms(i);
    if ( strcmp( atom.AtomName, 'C4''' ) )
        if ( length(atom.altLoc) == 0 || strcmp(atom.altLoc,'A'))
            coords3D = [coords3D; atom.X, atom.Y, atom.Z ];
            resName = [resName, {atom.resName}];
            resSeq  = [resSeq, atom.resSeq ];
        end
    end
end
