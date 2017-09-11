function stems = setup_residues( stems );
% also creates residues in appdata for gca
%
% (C) R. Das, Stanford University, 2017
sequence = getappdata( gca, 'sequence' );
resnum   = getappdata( gca, 'resnum' );
chains   = getappdata( gca, 'chains' );
non_standard_residues = getappdata( gca, 'non_standard_residues' );
% single stranded residues:

% following could probably be replaced with logic in
% reassign_parent_helix()
for n = 1:length( stems )
    stem_start1(n) = stems{n}.resnum1(1);
    stem_stop1 (n) = stems{n}.resnum1(end);
    stem_chain1(n) = stems{n}.chain1(1);
    stem_start2(n) = stems{n}.resnum2(1);
    stem_stop2 (n) = stems{n}.resnum2(end);
    stem_chain2(n) = stems{n}.chain2(1);
    stems{n}.associated_residues = {};
end
for i = 1:length(sequence)
    % find which helix is closest to the residue.
    chain = chains(i);
    res   = resnum(i);
    res_tag = sprintf('Residue_%s%d',chain,res);
    dists1 = Inf * ones( 1, length( stems ) );
    dists2 = Inf * ones( 1, length( stems ) );
    m = strfind( stem_chain1, chain );
    dists1(m) = min( abs( stem_start1(m) - res ), abs( abs(stem_stop1(m) - res) ) ); 
    m = strfind( stem_chain2, chain );
    dists2(m) = min( abs( stem_start2(m) - res ), abs( abs(stem_stop2(m) - res) ) ); 
    dists = min( dists1, dists2 );
    [~,n] = min( dists );
    stems{n}.associated_residues = [ stems{n}.associated_residues, res_tag ];

    residue.chain = chain;
    residue.resnum = res;
    residue.helix_tag = stems{n}.helix_tag;
    seqpos = intersect(strfind(chains,chain), find(resnum==res));
    residue.nucleotide = upper(sequence(seqpos));
    residue.linkers = {};
    setappdata( gca, res_tag, residue );
end