function [resnum,chains,segid] = get_resnum_from_string
%
%
%
resnum = [];
chains = '';
segid  = {};
cols = strsplit( resnum_string );
for i = 1:length( cols )
    [tag_resnum, tag_chains, tag_segids, ok ] = get_resnum_from_tag( cols{i} );
    if ( ok ) 
        resnum = [resnum, tag_resnum ];
        chains = [chains, tag_chains ];
        segid  = [segid, tag_segids ];
    end
end
