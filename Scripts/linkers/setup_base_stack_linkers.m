function setup_base_stack_linkers( base_stacks )
% draw_dummy_base_stacks( base_stacks )
%

plot_settings = getappdata(gca,'plot_settings');
for i = 1:length( base_stacks )
    base_stack = base_stacks{i};
    res_tag1 = sprintf('Residue_%s%s%d',base_stack.chain1,base_stack.segid1,base_stack.resnum1);
    res_tag2 = sprintf('Residue_%s%s%d',base_stack.chain2,base_stack.segid2,base_stack.resnum2);
    clear linker
    linker.residue1 = res_tag1;
    linker.residue2 = res_tag2;
    residue1 = getappdata( gca, res_tag1 );
    residue2 = getappdata( gca, res_tag2 );
    linker.type = 'stack';
    linker_tag = sprintf('Linker_%s%s%d_%s%s%d_%s',...
        base_stack.chain1,base_stack.segid1,base_stack.resnum1,...
        base_stack.chain2,base_stack.segid2,base_stack.resnum2,...
        linker.type);
    add_linker_to_residue( res_tag1, linker_tag );
    add_linker_to_residue( res_tag2, linker_tag );
    linker.linker_tag = linker_tag; 
    if ~isappdata( gca, linker_tag );  setappdata( gca, linker_tag, linker );  end
end

