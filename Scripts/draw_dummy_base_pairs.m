function draw_dummy_base_pairs( base_pairs )
% draw_dummy_base_pairs( base_pairs )
plot_settings = getappdata(gca,'plot_settings');
for i = 1:length( base_pairs )
    base_pair = base_pairs{i};
    res_tag1 = sprintf('Residue_%s%d',base_pair.chain1,base_pair.resnum1);
    res_tag2 = sprintf('Residue_%s%d',base_pair.chain2,base_pair.resnum2);
    clear linker
    linker.residue1 = res_tag1;
    linker.residue2 = res_tag2;
    linker.line_handle = plot( [0,0],[0,0],'k','linewidth',0.5 ); % dummy for now -- will get redrawn below.
    if ( base_pair.edge1 == base_pair.edge2 )
        linker.symbol = create_LW_symbol( base_pair.edge1, base_pair.LW_orientation, plot_settings.bp_spacing );
    else
        linker.symbol1 = create_LW_symbol( base_pair.edge1, base_pair.LW_orientation, plot_settings.bp_spacing );
        linker.symbol2 = create_LW_symbol( base_pair.edge2, base_pair.LW_orientation, plot_settings.bp_spacing );
    end
    add_linker_to_residue( res_tag1, linker );
    add_linker_to_residue( res_tag2, linker );
end

