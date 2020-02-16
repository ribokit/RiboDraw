function setup_basic_linkers( basics, type )
% setup_basic_linkers( basics )
%
%  Simple base function for taking objects like other_contacts or stacks
%   and installing them into the drawing (gca).
%
% Inputs:
%  basics = objects with chain1, segid1, resnum1, chain2, segid2, and resnum2 information.
%  type   = (string) type of linker to create.
%
% (C) R. Das, Stanford University, 2017.

for i = 1:length( basics )
    basic = basics{i};
    res_tag1 = sanitize_tag(sprintf('Residue_%s%s%d',basic.chain1,basic.segid1,basic.resnum1));
    res_tag2 = sanitize_tag(sprintf('Residue_%s%s%d',basic.chain2,basic.segid2,basic.resnum2));
    linker = struct();
    linker.residue1 = res_tag1;
    linker.residue2 = res_tag2;
    residue1 = getappdata( gca, res_tag1 );
    residue2 = getappdata( gca, res_tag2 );
    linker.type = type;
    linker_tag = sanitize_tag(sprintf('Linker_%s%s%d_%s%s%d_%s',...
        basic.chain1,basic.segid1,basic.resnum1,...
        basic.chain2,basic.segid2,basic.resnum2,...
        linker.type));
    add_linker_to_residue( res_tag1, linker_tag );
    add_linker_to_residue( res_tag2, linker_tag );
    linker.linker_tag = linker_tag; 
    if ~isappdata( gca, linker_tag );  setappdata( gca, linker_tag, linker );  end
end

