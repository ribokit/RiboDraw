function linker = autotrace_linker( linker );
% autotrace_linker( linker );
if iscell( linker ) 
    for i = 1:length( linker );  autotrace_linker(linker{i}); end;
    return;
end
if ischar( linker )
    autotrace_linker( getappdata(gca,linker) );
    return;
end

residue1 = getappdata(gca,linker.residue1);
residue2 = getappdata(gca,linker.residue2);

d = norm( residue1.plot_pos  - residue2.plot_pos );
plot_settings = getappdata(gca,'plot_settings');
if ( d < 2*plot_settings.bp_spacing) draw_linker( linker ); return; end;

helix1 = getappdata( gca, residue1.helix_tag );
helix2 = getappdata( gca, residue2.helix_tag );
vtx_plot_pos = [];

if isfield( residue1, 'ligand_partners' )
    % since ligand is a 'point', just draw one vertex based on 
    %   helix orientation of the other residue -- 'L-shapes'
    if mod(helix2.rotation,180) == 0
        vtx_plot_pos = [residue2.plot_pos(1),residue1.plot_pos(2)]; % L-shape
    else
        vtx_plot_pos = [residue1.plot_pos(1),residue2.plot_pos(2)]; % L-shape
    end
else
    if mod( helix1.rotation,180) > 0 && mod(helix2.rotation,180) == 0
        vtx_plot_pos = [residue2.plot_pos(1),residue1.plot_pos(2)]; % L-shape
    elseif mod( helix1.rotation,180) == 0 && mod(helix2.rotation,180) > 0
        vtx_plot_pos = [residue1.plot_pos(1),residue2.plot_pos(2)]; % L-shape
    elseif mod( helix1.rotation,180) > 0 && mod(helix2.rotation,180) > 0
        vtx_plot_pos = [(residue1.plot_pos(1)+residue2.plot_pos(1))/2,residue1.plot_pos(2); ...
            (residue1.plot_pos(1)+residue2.plot_pos(1))/2,residue2.plot_pos(2) ]; % zig-zag
    else
        assert( mod(helix1.rotation,180) == 0 );
        assert( mod(helix2.rotation,180) == 0 );
        vtx_plot_pos = [residue1.plot_pos(1),(residue1.plot_pos(2)+residue2.plot_pos(2))/2; ...
            residue2.plot_pos(1),(residue1.plot_pos(2)+residue2.plot_pos(2))/2 ]; % zig-zag
    end
end

linker.relpos1 = get_relpos( residue1.plot_pos, helix1 );
linker.relpos2 = get_relpos( [vtx_plot_pos; residue2.plot_pos], helix2 );
linker = draw_linker( linker );
setappdata( gca, linker.linker_tag, linker );

