function undraw_helix( helix )
for k = 1:length(helix.resnum1)
    delete( helix.bp(k) ); % generalize this
end

associated_res = helix.associated_residues;
for i = 1:length( associated_res )
    Residue = getappdata( gca, associated_res{i} );
    if isfield( Residue, 'handle' )
        delete( Residue.handle );
    end
end
delete( helix.l );
if isfield( helix, 'a_in1' ) delete( helix.a_in1 ); end;
if isfield( helix, 'a_in2' ) delete( helix.a_in2 ); end;
if isfield( helix, 'a_out1' ) delete( helix.a_out1 ); end;
if isfield( helix, 'a_out2' ) delete( helix.a_out2 ); end;
if isfield( helix, 'click_center' ) delete( helix.click_center ); end;
if isfield( helix, 'reflect_line' ) delete( helix.reflect_line ); end;
if isfield( helix, 'helix_rectangle' ) delete( helix.helix_rectangle ); end;

