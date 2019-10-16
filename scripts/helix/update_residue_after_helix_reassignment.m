function update_residue_after_helix_reassignment( residue )
% update_residue_after_helix_reassignment( residue )
%
%  update 'relpos' for residue and linkers after its helix_tag is shifted 
%
% (C) R. Das, Stanford University 2017,2019

helix = getappdata( gca, residue.helix_tag );
res_tag = residue.res_tag;
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
