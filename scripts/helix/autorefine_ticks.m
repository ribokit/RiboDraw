function [scores,sample_tickrot] = autorefine_tick( res_tags )
% autorefine_tick( res_tag )
sample_tickrot = [0:45:315];
scores = [];
if ~exist( 'res_tags','var' ); res_tags  = get_tags( 'Residue_' ); end;
if ischar( res_tags ) res_tags = {res_tags}; end;

axlim = axis();
figpos = get(gcf,'position');
plot_settings = getappdata( gca, 'plot_settings' );
fontsize = plot_settings.fontsize;
did_fontsize_resize = 0;
for i = 1:length( res_tags );
    res_tag = res_tags{i};
    residue = getappdata( gca, res_tag );
    if isfield( residue, 'tickrot' )
        fprintf( 'Refining: %s\n', res_tag );
        original_tickrot = residue.tickrot;
        
        plot_pos = residue.plot_pos;
        %set(gcf,'position',[0 0 200 200]);
        axis( [plot_pos(1)-25, plot_pos(1)+25,plot_pos(2)-25, plot_pos(2)+25] );
        if ~did_fontsize_resize; reset_fontsize(8); did_fontsize_resize = 1; end;
        plot_settings = getappdata( gca, 'plot_settings' );
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
        update_tick( residue, plot_settings, R);
        setappdata( gca, residue.res_tag, residue );
        cdata = screencapture(gca);
    end
end
    
%set( gcf, 'position', figpos);
axis( axlim );
if did_fontsize_resize; reset_fontsize( fontsize ); end;
