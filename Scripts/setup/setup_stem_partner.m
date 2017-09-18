function setup_stem_partner( stems );
% puts stem_partner information in Residue objects in appdata.
% (C) R. Das, Stanford University, 2017

% set up stem partner map to help define 'canonical' pairs.
for n = 1:length( stems )
    stem = stems{n};
    N = length( stem.resnum1 );
    for k = 1:N
        res_tag1 = sprintf( 'Residue_%s%d', stem.chain1(k), stem.resnum1(k) );
        res_tag2 = sprintf( 'Residue_%s%d', stem.chain2(N-k+1), stem.resnum2(N-k+1) );
        residue1 = getappdata( gca, res_tag1 );
        residue2 = getappdata( gca, res_tag2 );
        residue1.stem_partner = res_tag2;
        residue2.stem_partner = res_tag1;
        setappdata( gca, res_tag1, residue1 );
        setappdata( gca, res_tag2, residue2 );
    end
end
