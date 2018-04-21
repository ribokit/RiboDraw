function selection = update_selection_minpos_maxpos_ctrpos( selection, selection_tag );  
% selection = update_selection_minpos_maxpos_ctrpos( selection_tag );  
% selection = update_selection_minpos_maxpos_ctrpos( selection, selection_tag );  
%
% helper function that gets corners that define bounding box of selection.
%
% (C) R. Das, Stanford University
if ~exist( 'selection_tag', 'var' ) & ischar( selection )
    selection_tag = selection;
    selection = getappdata( gca, selection_tag );
end
dom_pos = [];
for j = 1:length( selection.associated_residues )
    residue = getappdata( gca, selection.associated_residues{j} );
    if isfield( residue, 'plot_pos' );
        dom_pos = [ dom_pos; residue.plot_pos ];
    end
end
selection.minpos = min( dom_pos, [], 1 );
selection.maxpos = max( dom_pos, [], 1 );
selection.ctrpos = (selection.minpos + selection.maxpos )/ 2;

% go ahead and update information in gca object.
setappdata( gca, selection_tag, selection );