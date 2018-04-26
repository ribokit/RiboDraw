function linker = autotrace_intradomain_linker( linker );
% autotrace_intradomain_linker( linker );
if ~exist( 'linker','var') linker = get_tags( 'Linker','intradomain'); end;
if iscell( linker ) 
    for i = 1:length( linker );  autotrace_intradomain_linker(linker{i}); end;
    return;
end
if ischar( linker )
    autotrace_intradomain_linker( getappdata(gca,linker) );
    return;
end

residue1 = getappdata(gca,linker.residue1);
residue2 = getappdata(gca,linker.residue2);

d = norm( residue1.plot_pos  - residue2.plot_pos );
plot_settings = getappdata(gca,'plot_settings');
if ( d < 2*plot_settings.bp_spacing) return; end;

helix1 = getappdata( gca, residue1.helix_tag );
helix2 = getappdata( gca, residue2.helix_tag );
vtx_plot_pos = [];

if mod( helix1.rotation,180) > 0 && mod(helix2.rotation,180) == 0
    vtx_plot_pos = [residue2.plot_pos(1),residue1.plot_pos(2)];
elseif mod( helix1.rotation,180) == 0 && mod(helix2.rotation,180) > 0  
    vtx_plot_pos = [residue1.plot_pos(1),residue2.plot_pos(2)];
elseif mod( helix1.rotation,180) > 0 && mod(helix2.rotation,180) > 0
    vtx_plot_pos = [(residue1.plot_pos(1)+residue2.plot_pos(1))/2,residue1.plot_pos(2); ...
                    (residue1.plot_pos(1)+residue2.plot_pos(1))/2,residue2.plot_pos(2) ];
else
    assert( mod(helix1.rotation,180) == 0 );
    assert( mod(helix2.rotation,180) == 0 );
    vtx_plot_pos = [residue1.plot_pos(1),(residue1.plot_pos(2)+residue2.plot_pos(2))/2; ...
                    residue2.plot_pos(1),(residue1.plot_pos(2)+residue2.plot_pos(2))/2 ];
end

linker.relpos1 = get_relpos( residue1.plot_pos, helix1 );
linker.relpos2 = get_relpos( [vtx_plot_pos; residue2.plot_pos], helix2 );
draw_linker( linker );
setappdata( gca, linker.linker_tag, linker );

