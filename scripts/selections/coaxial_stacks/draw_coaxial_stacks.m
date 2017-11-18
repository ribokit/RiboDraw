function draw_coaxial_stacks( coaxial_stacks )

plot_settings = getappdata( gca, 'plot_settings' );
for i = 1:length( coaxial_stacks )
    coax_color = rand(1,3);
    coax_pairs = coaxial_stacks{i}.coax_pairs;
    all_pos1 = [];all_pos2 = [];
    for j = 1:length( coax_pairs )
        coax_pair = coax_pairs{j};
        
        res_tag = sprintf( 'Residue_%s%s%d', coax_pair.chain1, coax_pair.segid1, coax_pair.resnum1 );
        residue = getappdata( gca, res_tag );
        set( residue.handle, 'color', coax_color );
        all_pos1(j,:) = residue.plot_pos;

        res_tag = sprintf( 'Residue_%s%s%d', coax_pair.chain2, coax_pair.segid2, coax_pair.resnum2 );
        residue = getappdata( gca, res_tag );
        set( residue.handle, 'color', coax_color );
        all_pos2(j,:) = residue.plot_pos;
    end
    
    
    minpos = min( [all_pos1; all_pos2 ] );
    maxpos = max( [all_pos1; all_pos2 ] );
    h = rectangle( 'Position',...
        [minpos(1) minpos(2) maxpos(1)-minpos(1) maxpos(2)-minpos(2) ]+...
        [-0.5 -0.5 1 1]*0.75*plot_settings.spacing,...
        'edgecolor',coax_color,'clipping','off');

end
