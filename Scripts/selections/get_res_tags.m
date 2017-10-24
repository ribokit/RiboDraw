function res_tags = get_res_tags( residue_string ); 
% res_tags = get_res_tags( residue_string ); 
% helper function that takes 'A:1-4' and gives back { 'Residue_A1',
% 'Residue_A2', 'Residue_A3', 'Residue_A4'};
res_tags = {};
if ischar( residue_string )
    [resnum, chains, ok ] = get_resnum_from_tag( residue_string );
    if ~ok;  fprintf( 'unrecognized tag: %s. Should be of form A:1-4 C:50-67\n', residue_string ); end
    for i = 1:length( resnum )
        res_tags = [res_tags, sprintf( 'Residue_%s%d', chains(i),resnum(i) ) ];
    end
elseif iscell( residue_string )
    res_tags = residue_string;
end
