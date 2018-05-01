function set_artboards();
% set_artboards();
%
% Reset the axis limits of the figure based on the minimum and
%  maximum position of the residues. (Plus an extra +/- 2.5% margin.)
%
% (C) R. Das, Stanford University, 2017

all_pos = [];

res_tags = get_tags( 'Residue_' );
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    if isfield( residue, 'plot_pos' )
        all_pos = [all_pos; residue.plot_pos ];
    end
end
%
% Maybe we should restore this (at least look over visible linkers) and
%  also look over text labels.
%
%     if isfield( residue, 'linkers' )
%         for j = 1:length( residue.linkers )
%             linker = getappdata( gca, residue.linkers{j} );
%             if isfield( linker, 'vtx' )
%                 for k = 1:length( linker.vtx )
%                     vtx_x = get( linker.vtx{k}, 'XData' );
%                     vtx_y = get( linker.vtx{k}, 'YData' );
%                     all_pos = [all_pos; vtx_x, vtx_y ];
%                 end
%             end
%         end
%     end

tags = fields(getappdata(gca));
for i = 1:length( tags )
     obj = getappdata( gca, tags{i} );
     if isfield( obj, 'label' ) 
         if strcmp(get(obj.label,'visible'),'on')
             label_pos =  get(obj.label,'position');
             all_pos = [all_pos; label_pos(1:2)];
         end
     end
 end

min_pos = min( all_pos );
max_pos = max( all_pos );
dims = (max_pos - min_pos);
plot_settings = getappdata( gca, 'plot_settings' );
fontsize_in_axis_units = plot_settings.fontsize / get_fontsize_over_axisunits();
nudge_pos = max( dims*0.025, 2*fontsize_in_axis_units * [1 1]);
axes =  [min_pos - nudge_pos; min_pos + dims + nudge_pos ];
 
axis( reshape( axes, [1 4] ) );
update_artboards();
update_graphics_size();
