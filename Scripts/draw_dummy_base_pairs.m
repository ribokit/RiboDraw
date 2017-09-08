function draw_dummy_base_pairs( base_pairs, stem_pair_map )
% draw_dummy_base_pairs( base_pairs )

if ~exist( 'stem_pair_map', 'var'); stem_pair_map.partner1 = {}; stem_pair_map.partner2 = {} ; end;
plot_settings = getappdata(gca,'plot_settings');
for i = 1:length( base_pairs )
    base_pair = base_pairs{i};
    res_tag1 = sprintf('Residue_%s%d',base_pair.chain1,base_pair.resnum1);
    res_tag2 = sprintf('Residue_%s%d',base_pair.chain2,base_pair.resnum2);
    clear linker
    linker.residue1 = res_tag1;
    linker.residue2 = res_tag2;
    residue1 = getappdata( gca, res_tag1 );
    residue2 = getappdata( gca, res_tag2 );
    if isfield( residue1, 'stem_partner' ) & strcmp( residue1.stem_partner, res_tag2 )
        linker.type = 'stem_pair';
        bp = [residue1.nucleotide,residue2.nucleotide];
        switch bp
            case {'AU','UA','GC','CG' }
                linker.line_handle = plot( [0,0],[0,0],'k','linewidth',0.5 ); % dummy for now -- will get redrawn below.
            case {'GU','UG'}
                linker.symbol = create_LW_symbol( 'W', 'C', plot_settings.bp_spacing );
        end
    else
        linker.type = 'noncanonical_pair';
        linker.line_handle = plot( [0,0],[0,0],'k','linewidth',0.5 ); % dummy for now -- will get redrawn below.
        if ( base_pair.edge1 == base_pair.edge2 )
            linker.symbol = create_LW_symbol( base_pair.edge1, base_pair.LW_orientation, plot_settings.bp_spacing );
        else
            linker.symbol1 = create_LW_symbol( base_pair.edge1, base_pair.LW_orientation, plot_settings.bp_spacing );
            linker.symbol2 = create_LW_symbol( base_pair.edge2, base_pair.LW_orientation, plot_settings.bp_spacing );
        end
    end
    add_linker_to_residue( res_tag1, linker );
    add_linker_to_residue( res_tag2, linker );
end

