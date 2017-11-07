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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ res_tags, obj_name ] = get_res( selection )
res_tags = {};
obj_name = '';
if strcmp( selection, 'all' )
    res_tags = get_tags( 'Residue_' );
else
    [resnum,chains,segid,ok] = get_resnum_from_tag( selection );
    if ok 
        for i = 1:length( resnum )
            res_tag = sprintf( 'Residue_%s%s%d', chains(i), segid{i}, resnum(i) );
            if isappdata( gca, res_tag )
                res_tags = [res_tags, res_tag ];
            end
        end
    else
        vals = getappdata( gca );
        objnames = fields( vals );
        if any( strcmp( objnames, selection ) )
            obj = getappdata( gca, selection );
            if isfield( obj, 'associated_residues' )
                res_tags = obj.associated_residues;
            else
                res_tags = { selection };
            end
            obj_name = selection;
        else
            for n = 1:length( objnames )
                obj = getappdata( gca, objnames{n} );
                if isfield( obj, 'associated_residues' ) & ...
                    isfield( obj, 'name' ) & ...
                    strcmp( obj.name, selection )
                    res_tags = obj.associated_residues;
                    obj_name = objnames{n};
                    break;
                end
                if isfield( obj, 'nucleotide' ) & ...
                       strcmp( obj.nucleotide, selection )
                    res_tags = { objnames{n} };
                    obj_name = objnames{n};
                    break;
                end
            end
        end 
    end
end

if length( res_tags ) == 0
    obj_name = '';
    fprintf( 'Could not find residues for selection %s\n', selection );
    return;
end

reschain = {};
% now sort based on order
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    reschain{i} = sprintf( '%2s%09d', residue.chain, residue.resnum );
end
[~,idx] = sort( reschain );
res_tags = res_tags( idx );
