function set_artboards();
% set_artboards();
%
% Reset the axis limits of the figure based on the minimum and
%  maximum position of the residues. (Plus an extra +/- 2.5% margin.)
%
% (C) R. Das, Stanford University, 2017

res_tags = get_tags( 'Residue_' );
all_pos = [];
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    if isfield( residue, 'plot_pos' )
        all_pos = [all_pos; residue.plot_pos ];
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
end

min_pos = min( all_pos );
max_pos = max( all_pos );
dims = (max_pos - min_pos);
axes =  [min_pos - dims*0.025; min_pos + dims*1.025 ];
 
axis( reshape( axes, [1 4] ) );
reset_fontsize
