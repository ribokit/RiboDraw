function color_drawing( color, selection )
% color_drawing( color, selection )
%
% color = 'rainbow' (to match Pymol), 'black', 'k', 'teal',...
% selection = 'C:1-125', 'H54b', etc.
%
%  Still need to update selection.
%
% (C) R. Das, Stanford University.

resnum = get_resnum();
nres = length( resnum );
if ischar( color ) & strcmp(color,'rainbow')
    res_colors = pymol_rainbow( nres );
else
    res_colors = repmat( rgb( color ), nres, 1);
end

count = 0;
vals = getappdata( gca );
objnames = fields( vals );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Residue_' ) );
        residue = getappdata( gca, objnames{n} );
        count = find( resnum == residue.resnum );
        residue.rgb_color = res_colors(count,:);
        if isfield( residue, 'handle' ) set( residue.handle, 'color', residue.rgb_color ); end;
        setappdata( gca, objnames{n}, residue);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resnum = get_resnum()
resnum = [];
vals = getappdata( gca );
objnames = fields( vals );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Residue_' ) );
        residue = getappdata( gca, objnames{n} );
        resnum = [resnum, residue.resnum ];
    end
end
resnum = sort( resnum );
