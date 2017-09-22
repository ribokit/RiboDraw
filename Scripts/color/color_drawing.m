function color_drawing( color, selection )
% color_drawing( color, selection )
%
% color = 'rainbow' (to match Pymol), 'black', 'k', 'teal',...
% selection = 'C:1-125', 'H54b', etc.
%
%  Still need to update selection.
%
% (C) R. Das, Stanford University.

[ res_tags, obj_name ] = get_res( selection );

nres = length( res_tags );
if ischar( color ) & strcmp(color,'rainbow')
    res_colors = pymol_rainbow( nres );
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
    for n = 1:length( objnames )
        if ~isempty( strfind( objnames{n}, 'Residue_' ) );
            res_tags = objnames{n};
        end
    end
else
    [resnum,chains,ok] = get_resnum_from_tag( selection );
    if ok 
        for i = 1:length( resnum )
            res_tag = sprintf( 'Residue_%s%d', resnum(i), chains(i) );
            if isappdata( gca, res_tag )
                res_tags = [res_tags, res_tag ];
            end
        end
    else
        vals = getappdata( gca );
        objnames = fields( vals );
        if strcmp( objnames, selection )
            obj = getappdata( gca, selection );
            res_tags = obj.associated_residues;
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
