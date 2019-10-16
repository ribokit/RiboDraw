function [secstruct,res_tags] = get_secstruct_from_drawing()
% [secstruct,res_tags] = get_secstruct_from_drawing()
% 
%  Output secstruct using dot-parentheses notation.
%
% (C) R. Das, Stanford University, 2019

[~,res_tags] = get_RNA_chains();

helix_tags = get_tags( 'Helix' );
bps = [];
for n = 1:length( helix_tags );
    helix = getappdata( gca, helix_tags{n} );
    N = length( helix.resnum1 );
    for j = 1:N
        res_tag1 = sprintf('Residue_%s%s%d',helix.chain1(j), helix.segid1{j}, helix.resnum1(j));
        res_tag2 = sprintf('Residue_%s%s%d', helix.chain2(N-j+1), helix.segid2{j}, helix.resnum2(N-j+1));
        m = find( strcmp( res_tags, res_tag1 ) );
        n = find( strcmp( res_tags, res_tag2 ) );
        bps = [bps; m, n];
    end
end

secstruct = convert_bps_to_structure( bps, length(res_tags) );