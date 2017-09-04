function redraw_helix( h )
pos = get(h,'position'); 
startpos = getappdata( h, 'startpos' );

gca_helix_tag = sprintf('Helix%d',startpos);
helix = getappdata(gca,gca_helix_tag );

helix.center = [ pos(1) + pos(3)/2, pos(2) + pos(4)/2];
delete( h );
for k = 1:length(helix.resnum1)
    delete( helix.s1(k) );
    delete( helix.s2(k) );
    delete( helix.bp(k) );
end
delete( helix.l );
delete( helix.a_in1 );
delete( helix.a_out2 );
delete( helix.a_out1 );
delete( helix.a_in2 );

% draws another draggable rectangle. The only way I've got this to work.
setappdata(gca,gca_helix_tag,draw_helix( helix ));


