function draw_dummy_ticks();
% draw_dummy_ticks()
% draw ticks at dummy locations.
% would be better to split this into initialization routine

vals = getappdata( gca );
objnames = fields( vals );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Residue_' ) );
        residue = getappdata( gca, objnames{n} );
        if isfield( residue, 'tickrot' )
            residue.tick_handle = plot( [0,0],[0,0],'k','linewidth',0.5); % dummy for now -- will get redrawn later.
            residue.tick_label = text( 0, 0, num2str(residue.resnum), 'fontsize', 10, 'horizontalalign','center','verticalalign','middle' );
            setappdata( gca, objnames{n}, residue );
        end
    end
end
