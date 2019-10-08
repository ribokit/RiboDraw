function secstruct = get_secstruct_from_drawing()
% secstruct = get_secstruct_from_drawing()
% 
%  Output secstruct using dot-parentheses notation.
%
% (C) R. Das, Stanford University, 2019

res_tags = get_res();
N = length( res_tags ); % may need to update later to weed out proteins.

linker_tags = get_tags( 'Linker','stem_pair');
bps = [];
for i = 1:length( linker_tags )
    linker = getappdata( gca, linker_tags{i} );
    m = find( strcmp( res_tags, linker.residue1 ) );
    n = find( strcmp( res_tags, linker.residue2 ) );
    bps = [bps; m, n];
end

secstruct = convert_bps_to_structure( bps, N );