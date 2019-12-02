function [minpos,maxpos] = get_minpos_maxpos( associated_residues );  
% [minpos,maxpos] = get_minpos_maxpos( selection );  
% [minpos,maxpos] = get_minpos_maxpos( associated_residues );  
%
% helper function that gets corners that define bounding box of selection.
%
% (C) R. Das, Stanford University

if isstruct( associated_residues ) 
    selection = associated_residues;
    assert( isfield( selection, 'associated_residues' ) );
    associated_residues = selection.associated_residues; 
end;

dom_pos = [];
for j = 1:length( associated_residues )
    residue = getappdata( gca, associated_residues{j} );
    if isfield( residue, 'plot_pos' );
        dom_pos = [ dom_pos; residue.plot_pos ];
    end
end
minpos = min( dom_pos, [], 1 );
maxpos = max( dom_pos, [], 1 );
