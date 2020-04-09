function set_fontcolor( color, res_tags )
% set_fontcolor( setting, res_tags )
%
% Set font color for a selection of residues (or all of them).
%
% (C) R. Das, Stanford University, 2017


% if you don't pass res_tags, get all residues.
if nargin < 2
    res_tags = get_tags( 'Residue' );
end;

for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    if isfield( residue, 'handle' ) 
        set( residue.handle, 'color', pymol_RGB( color ) );
    end
end
