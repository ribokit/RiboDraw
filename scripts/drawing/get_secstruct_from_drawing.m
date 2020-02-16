function [secstruct,res_tags] = get_secstruct_from_drawing( selection )
% [secstruct,res_tags] = get_secstruct_from_drawing()
% [secstruct,res_tags] = get_secstruct_from_drawing( selection )
% 
%  Output secstruct using dot-parentheses notation.
%
% (C) R. Das, Stanford University, 2019

if ~exist( 'selection' ) selection = 'all'; end;
[~,res_tags] = get_RNA_chains( selection );

helix_tags = get_tags( 'Helix' );
bps = [];
for n = 1:length( helix_tags );
    helix = getappdata( gca, helix_tags{n} );
    N = length( helix.resnum1 );
    for j = 1:N
        res_tag1 = sanitize_tag(sprintf('Residue_%s%s%d',helix.chain1(j), helix.segid1{j}, helix.resnum1(j));
        res_tag2 = sanitize_tag(sprintf('Residue_%s%s%d', helix.chain2(N-j+1), helix.segid2{j}, helix.resnum2(N-j+1));
        m = find( strcmp( res_tags, res_tag1 ) );
        n = find( strcmp( res_tags, res_tag2 ) );
        if isempty( m ); continue;end;
        if isempty( n ); continue;end;
        bps = [bps; m, n];
    end
end

secstruct = ribodraw_convert_bps_to_structure( bps, length(res_tags) );
