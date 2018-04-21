function [minpos,maxpos,ctrpos] = get_minpos_maxpos_ctrpos( selection, all_res_plot_pos, all_res_tags );  
% [minpos,maxpos,ctrpos] = get_minpos_maxpos_ctrpos( selection );  
%
% helper function that gets corners that define bounding box of selection.
%
% (C) R. Das, Stanford University
dom_pos = [];
 
if exist( 'all_res_plot_pos','var' ) & exist( 'all_res_tags','var' )
    for j = 1:length( selection.associated_residues )
        m = find(strcmp( selection.associated_residues{j} ));
        if ~isnan( all( all_res_plot_pos(:,m) ) )
            dom_pos = [ dom_pos; all_res_plot_pos(:,m) ];
        end
    end
else
    for j = 1:length( selection.associated_residues )
        residue = getappdata( gca, selection.associated_residues{j} );
        if isfield( residue, 'plot_pos' );
            dom_pos = [ dom_pos; residue.plot_pos ];
        end
    end
end
minpos = min( dom_pos, [], 1 );
maxpos = max( dom_pos, [], 1 );
ctrpos = (minpos + maxpos )/ 2;

