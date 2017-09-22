function redraw_helix( h )
delete_crosshair();
if ischar( h ) % might be specifying by name
    tags = get_tags( 'Helix' );
    for i = 1:length( tags )
        helix = getappdata( gca, tags{i} );
        if strcmp( helix.name, h ) 
            redraw_helix( helix.rectangle );
            return;
        end
    end
end
helix_tag = getappdata( h, 'helix_tag' );
helix = getappdata(gca,helix_tag );

pos = get(h,'Position')
helix.center = [ pos(1) + pos(3)/2, pos(2) + pos(4)/2];
setappdata( gca, helix_tag, helix );

undraw_helix( helix );
draw_helix( helix );


