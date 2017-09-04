function redraw_helix( h )
pos = get(h,'position'); 
helix_tag = getappdata( h, 'helix_tag' );
helix = getappdata(gca,helix_tag );

helix.center = [ pos(1) + pos(3)/2, pos(2) + pos(4)/2];
delete( h );
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

draw_helix( helix );


