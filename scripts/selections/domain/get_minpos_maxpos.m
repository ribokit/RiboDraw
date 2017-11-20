function [minpos,maxpos] = get_minpos_maxpos( selection );  
% [minpos,maxpos] = get_minpos_maxpos( selection );  
%
% helper function that gets corners that define bounding box of selection.
%
% (C) R. Das, Stanford University

dom_pos = [];
for j = 1:length( selection.associated_residues )
    residue = getappdata( gca, selection.associated_residues{j} );
    if isfield( residue, 'plot_pos' );
        dom_pos = [ dom_pos; residue.plot_pos ];
    end
end
minpos = min( dom_pos, [], 1 );
maxpos = max( dom_pos, [], 1 );
