function redraw_res_and_helix( h )
% Redraw residue and any other residues associated with its parent helix.
% Call this after dragging.
% (C) R. Das, Stanford University, 2017
delete_crosshair();
pos = get(h,'position');
res_tag = getappdata( h, 'res_tag' );
residue = getappdata(gca,res_tag );
original_plot_pos = residue.plot_pos;
if length( pos ) == 4 % rectangle
    residue.plot_pos = [ pos(1) + pos(3)/2, pos(2) + pos(4)/2];
else
    residue.plot_pos = pos(1:2);
end
[residue,switched_helix] = reassign_parent_helix( residue );
if (switched_helix) residue.plot_pos = original_plot_pos; end;

helix = getappdata( gca, residue.helix_tag );
blink_helix_rectangle( helix );

% need to figure out rel_pos back in the 'frame' of the helix.
% for that I need to figure out rotation matrix.
residue.relpos = get_relpos( residue.plot_pos, helix );
linker_tags = residue.linkers;
for k = 1 : length( linker_tags )
    linker = getappdata( gca, linker_tags{k} );
    if ~isfield( linker, 'line_handle' ) continue; end; % may not have been rendered yet.
    if strcmp(linker.residue1, res_tag )
        n1 = size(linker.relpos1,1);
        linker.relpos1 = get_relpos( linker.plot_pos(1:n1,:), helix );
    end
    if strcmp(linker.residue2, res_tag )
        n2 = size(linker.relpos2,1);
        linker.relpos2 = get_relpos( linker.plot_pos(end-n2+1:end,:), helix );
    end
    setappdata( gca, linker_tags{k}, linker );
end
setappdata( gca, res_tag, residue );
draw_helix( helix );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function blink_helix_rectangle( helix );
% provide some visual feedback to user.
if isfield(helix,'rectangle')
    color = get( helix.rectangle, 'edgecolor' );
    set( helix.rectangle,'edgecolor','k' );
    pause(0.2)
    set( helix.rectangle,'edgecolor',color );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [residue,switched_helix] = reassign_parent_helix( residue )
% If residue is far from parent helix and inside the rectangle for
% another helix, switch its parent.
%
% Relies on plotpos.
%
% Does *not* handle relpos
%
% possible helix parents -- judge based on sequence.

switched_helix = 0;

% if the residue was moved into its current helix, don't do anything...
current_helix = getappdata( gca, residue.helix_tag );
if ( check_in_helix_rectangle( residue, current_helix ) )
    switched_helix = 1;
    return;
end

stems = get_stems();   
for n = 1:length( stems )
    other_helix = stems{n};
    if ( check_in_helix_rectangle( residue, other_helix ) )
        switched_helix = 1;
        % do the switch
        current_helix.associated_residues = setdiff( current_helix.associated_residues, residue.res_tag );
        setappdata( gca, current_helix.helix_tag, current_helix );
        
        other_helix.associated_residues = sort( [other_helix.associated_residues, residue.res_tag] );
        setappdata( gca, other_helix.helix_tag, other_helix );
        
        residue.helix_tag = other_helix.helix_tag;
         return;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function ok = check_neighbor( residue, helix )
% ok = 0;
% plot_settings = getappdata( gca, 'plot_settings' );
% nbr_spacing = plot_settings.bp_spacing;
% for i = 1:length( helix.associated_residues )
%     other_res_tag = helix.associated_residues{i};
%     if strcmp( other_res_tag, residue.res_tag ) continue; end;
%     other_residue = getappdata( gca, other_res_tag);
%     dist = norm( other_residue.plot_pos - residue.plot_pos );
%     if ( dist <= nbr_spacing )
%         ok = 1;
%         return;
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ok = check_in_helix_rectangle( residue, helix )
if ~isfield( helix, 'rectangle' ) return; end;
pos = get( helix.rectangle, 'Position' );
ok = ( ...
    residue.plot_pos(1) >= pos(1) & ...
    residue.plot_pos(1) <= pos(1)+pos(3) & ...
    residue.plot_pos(2) >= pos(2) & ...
    residue.plot_pos(2) <= pos(2)+pos(4) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stems = get_stems();
vals = getappdata( gca );
objnames = fields( vals );
stems = {};
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Helix_' ) );
        stems = [stems, getappdata( gca, objnames{n} ) ];
    end
end
