function set_artboards();

res_tags = get_tags( 'Residue_' );
all_pos = [];
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    if isfield( residue, 'plot_pos' )
        all_pos = [all_pos; residue.plot_pos ];
    end
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
axes =  [min_pos - dims*0.05; min_pos + dims*1.1 ];
 
axis( reshape( axes, [1 4] ) );
reset_fontsize
