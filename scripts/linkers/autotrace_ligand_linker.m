function linker = autotrace_ligand_linker( linker );
% autotrace_ligand_linker( linker );
if ~exist( 'linker','var') linker = get_tags( 'Linker','ligand'); end;
if iscell( linker ) 
    for i = 1:length( linker );  autotrace_ligand_linker(linker{i}); end;
    return;
end
if ischar( linker )
    autotrace_ligand_linker( getappdata(gca,linker) );
    return;
end

residue1 = getappdata(gca,linker.residue1);
residue2 = getappdata(gca,linker.residue2);
helix1 = getappdata( gca, residue1.helix_tag );
helix2 = getappdata( gca, residue2.helix_tag );
if mod(helix2.rotation,180) == 0
    vtx_plot_pos = [residue2.plot_pos(1),residue1.plot_pos(2)];
else
    vtx_plot_pos = [residue1.plot_pos(1),residue2.plot_pos(2)];
end
linker.relpos1 = get_relpos( residue1.plot_pos, helix1 );
linker.relpos2 = get_relpos( [vtx_plot_pos; residue2.plot_pos], helix2 );
draw_linker( linker );
setappdata( gca, linker.linker_tag, linker );

