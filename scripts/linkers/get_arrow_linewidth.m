function arrow_linewidth = get_arrow_linewidth( fontsize );
% arrow_linewidth = get_arrow_linewidth( fontsize );
%
% Heuristic for scaling arrow line width to fontsize
% from 0.6 at thinnest to fontsize x 1.5/10 at thickest.
%
% (C) R. Das, Stanford University.

arrow_linewidth = max( 0.6, fontsize*1.5/10 );
