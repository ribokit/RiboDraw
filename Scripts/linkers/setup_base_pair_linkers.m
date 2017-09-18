function setup_base_pair_linkers( base_pairs )
% draw_dummy_base_pairs( base_pairs )
%
%

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
    else
        linker.type = 'noncanonical_pair';
        linker.edge1 = base_pair.edge1;
        linker.edge2 = base_pair.edge2;
        linker.LW_orientation = base_pair.LW_orientation;
    end
    linker_tag = sprintf('Linker_%s%d_%s%d_%s', base_pair.chain1,base_pair.resnum1,base_pair.chain2,base_pair.resnum2,linker.type);
    add_linker_to_residue( res_tag1, linker_tag );
    add_linker_to_residue( res_tag2, linker_tag );
    linker.linker_tag = linker_tag; 
    if ~isappdata( gca, linker_tag );  setappdata( gca, linker_tag, linker );  end
end

