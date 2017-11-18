function [minpos,maxpos] = get_minpos_maxpos( selection );  
dom_pos = [];
for j = 1:length( selection.associated_residues )
    residue = getappdata( gca, selection.associated_residues{j} );
    if isfield( residue, 'plot_pos' );
        dom_pos = [ dom_pos; residue.plot_pos ];
    end
end
minpos = min( dom_pos, [], 1 );
maxpos = max( dom_pos, [], 1 );
