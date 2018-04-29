function [scores,sample_tickrot] = autorefine_tick( res_tag )
% autorefine_tick( res_tag )
sample_tickrot = [0:45:315];
scores = [];
if ~exist( 'res_tag','var' ); res_tag  = get_tags( 'Residue_' ); end;
if iscell( res_tag )
    for i = 1:length( res_tag ); 
        [scores,sample_tickrot] = autorefine_tick( res_tag{i} );
    end
    return;
end

residue = getappdata( gca, res_tag );
tic
axlim = axis();
plot_settings = getappdata( gca, 'plot_settings' );
if isfield( residue, 'tickrot' )
    fprintf( 'Refining: %s\n', res_tag );
    original_tickrot = residue.tickrot;

    plot_pos = residue.plot_pos;
    axis( [plot_pos(1)-50, plot_pos(1)+50,plot_pos(2)-50, plot_pos(2)+50] );
    reset_fontsize();
    helix = getappdata( gca, residue.helix_tag );
    R = get_helix_rotation_matrix( helix ); 
    for j = 1:length( sample_tickrot ) 
        tickrot = sample_tickrot(j);
        residue.tickrot = tickrot;
        setappdata( gca, residue.res_tag, residue );
        update_tick( residue, plot_settings, R); 
        %cdata = print('-RGBImage','-r50');
        cdata = screencapture(gca);
        scores(j) = sum(sum(sum(cdata)));
    end
    [~,idx] = min( scores );
    residue.tickrot = sample_tickrot( idx );
    setappdata( gca, residue.res_tag, residue );
    draw_helix( residue.helix_tag );
    cdata = screencapture(gca);
    axis( axlim );
end
toc

