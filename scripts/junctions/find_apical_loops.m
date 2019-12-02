function apical_loops = find_apical_loops()
% find_apical_loops()
%
% (C) R. Das, Stanford University, 2019

helix_tags = get_tags( 'Helix' );

res_tags_in_helices = {};
for i = 1:length( helix_tags )
    helix = getappdata( gca, helix_tags{i} );
    N = length( helix.resnum1 );
    for j = 1:N
        res_tag1 = sprintf('Residue_%s%s%d',helix.chain1(j), helix.segid1{j}, helix.resnum1(j));
        res_tag2 = sprintf('Residue_%s%s%d', helix.chain2(N-j+1), helix.segid2{j}, helix.resnum2(N-j+1));
        res_tags_in_helices = [ res_tags_in_helices, {res_tag1,res_tag2} ];
    end
end
    
apical_loops = {};
for i = 1:length( helix_tags )
    helix = getappdata( gca, helix_tags{i} );
    N = length( helix.resnum1 );
    if ~strcmp( helix.chain1(N), helix.chain2(1) ) continue; end;
    if ~strcmp( helix.segid1{N}, helix.segid2{1} ) continue; end;
    chain = helix.chain1(N);
    segid = helix.segid1{N};
    ok = 1;
    apical_loop = {};
    for resnum = helix.resnum1(N)+1 : helix.resnum2(1)-1
        res_tag = sprintf('Residue_%s%s%d', chain, segid, resnum);
        if ~isappdata( gca, res_tag )
            % chainbreak or something.
            ok = 0; 
            break;
        end
        if ~isempty( find( strcmp( res_tags_in_helices, res_tag ) ) ) 
            % this is residue is paired. game over.
            ok = 0;
            break; 
        end
        apical_loop = [ apical_loop, {res_tag} ];
    end
    if ~ok; continue; end;
    apical_loops = [ apical_loops, {apical_loop} ];
end

