function undraw_helix( helix )
for k = 1:length(helix.resnum1)
    delete( helix.s1(k) );
    delete( helix.s2(k) );
    delete( helix.bp(k) );
end
delete( helix.l );
if isfield( helix, 'a_in1' ) delete( helix.a_in1 ); end;
if isfield( helix, 'a_in2' ) delete( helix.a_in2 ); end;
if isfield( helix, 'a_out1' ) delete( helix.a_out1 ); end;
if isfield( helix, 'a_out2' ) delete( helix.a_out2 ); end;
if isfield( helix, 'clickcenter' ) delete( helix.clickcenter ); end;
if isfield( helix, 'helix_rectangle' ) delete( helix.helix_rectangle ); end;

