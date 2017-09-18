function draw_dummy_base_pairs()
% 
for i = 1:length( base_pairs )
    base_pair = base_pairs{i};
    clear linker
    res_tag1 = sprintf('Residue_%s%d',chain1(i),resnum1(i));
    res_tag2 = sprintf('Residue_%s%d',chain2(j),resnum2(j));
    linker.residue1 = res_tag1;
    linker.residue2 = res_tag2;
    linker.line_handle = plot( [0,0],[0,0],'k','linewidth',1.2 ); % dummy for now -- will get redrawn below.
    if ( linker.edge1 == linker.edge2 )
        linker.symbol = create_symbol( linker.edge1 );
        set( linker.symbol, 'facecolor', fill_color( linker.LW_orientation ) );
    else
        linker.symbol1 = create_symbol( linker.edge1 );
        linker.symbol2 = create_symbol( linker.edge2 );
        set( linker.symbol, 'facecolor', fill_color( linker.LW_orientation ) );
    end
end

