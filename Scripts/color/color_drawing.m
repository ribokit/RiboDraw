function color_drawing( color, selection )
% color_drawing( color, selection )
%
% Color a domain, helix, or arbitrary set of residues a particular color, or
%   in rainbow. 
% 
% color = RGB color in a variety of possible formats:
%         'rainbow' (matches Pymol spectrum, red to blue by residue number)
%         'black', 'k', ... (MATLAB color string) 
%         'teal','marine', ... (Pymol color string)
%         [0,0,1] for RGB color setting (triplet of numbers between 0 to 1)
%
% selection = 'C:1-125', 'H54b', etc.  [default: 'all']
%
% (C) R. Das, Stanford University.

if ~exist( 'selection', 'var' ) selection = 'all'; end;
[ res_tags, obj_name ] = get_res( selection );

nres = length( res_tags );
if ischar( color ) & strcmp(color,'rainbow')
    for i = 1:length( res_tags ); 
        residue = getappdata( gca, res_tags{i} );
        resnum(i) = residue.resnum;
    end
    all_resnum = [min(resnum):max(resnum)];
    all_res_colors = pymol_rainbow( length(all_resnum) );
    res_colors = all_res_colors( resnum - min(resnum) + 1, :);
    label_color = [0,0,0];
else
    rgb_color = pymol_RGB( color );
    res_colors = repmat( rgb_color, nres, 1);
    label_color = rgb_color;
end

for n = 1:length( res_tags )
    res_tag = res_tags{n};
    residue = getappdata( gca, res_tag );
    residue.rgb_color = res_colors(n,:);
    if isfield( residue, 'handle' ) set( residue.handle, 'color', residue.rgb_color ); end;
    setappdata( gca, res_tag, residue);
    draw_helix( residue.helix_tag );
end

if length( obj_name ) > 0
    obj = getappdata( gca, obj_name );
    obj.rgb_color = label_color;
    if isfield( obj, 'label' ); set( obj.label, 'color', label_color );    end
    setappdata( gca, obj_name, obj );
end

