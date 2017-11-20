ifunction res_tags = get_res_tags( residue_string, check_exists ); 
% res_tags = get_res_tags( residue_string ); 
%
% helper function that takes 'A:1-4' and gives back { 'Residue_A1',
% 'Residue_A2', 'Residue_A3', 'Residue_A4'};
%
% May be redundant with GET_RES().
%
% (C) R. Das, Stanford University.
if ~exist( 'check_exists','var') check_exists = 0; end;
res_tags = {};
if ischar( residue_string )
    [resnum, chains, segid, ok ] = get_resnum_from_tag( residue_string );
    if ~ok;  fprintf( 'unrecognized tag: %s. Should be of form A:1-4 C:50-67\n', residue_string ); end
    for i = 1:length( resnum )
        res_tag = sprintf( 'Residue_%s%s%d', chains(i),segid{i},resnum(i) );
        if ( check_exists & ~isappdata( gca, res_tag) ) continue; end;
        res_tags = [res_tags, res_tag ];
    end
elseif iscell( residue_string )
    res_tags = residue_string;
end
