function undraw_helix( helix )
% also deletes residues in helix and associated with helix.
% (C) R. Das, Stanford University, 2017

associated_res = helix.associated_residues;
for i = 1:length( associated_res )
    Residue = getappdata( gca, associated_res{i} );
    % if isfield( Residue, 'handle' ); delete( Residue.handle ); end
end
delete( helix.l );
if isfield( helix, 'click_center' ) delete( helix.click_center ); end;
if isfield( helix, 'reflect_line' ) delete( helix.reflect_line ); end;
if isfield( helix, 'reflect_line1' ) delete( helix.reflect_line1 ); end;
if isfield( helix, 'reflect_line2' ) delete( helix.reflect_line2 ); end;
if isfield( helix, 'helix_rectangle' ) delete( helix.helix_rectangle ); end;

