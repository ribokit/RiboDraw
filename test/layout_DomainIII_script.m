% eventually need to move these loops into separate functions.
stems = read_stems( '4ybb_DIII_stems.txt' );
[sequence,resnum,chains,non_standard_residues] = get_sequence( '4ybb_DomainIII.fasta' );
setappdata( gca, 'sequence', sequence );
setappdata( gca, 'resnum', resnum );
setappdata( gca, 'chains', chains );
setappdata( gca, 'non_standard_residues', non_standard_residues );
setappdata( gca, 'stems', stems );
base_pairs = read_base_pairs( '4ybb_DIII_base_pairs.txt' ); % includes noncanonical pairs.
setappdata( gca, 'base_pairs', base_pairs );

clf; set(gca,'Position',[0 0 1 1]);
hold on
t = zeros( 1, length(sequence ) );
axis( [0 200 0 200] );

plot_settings.fontsize   =10;
plot_settings.spacing    = 3;
plot_settings.bp_spacing = 6;
setappdata( gca, 'plot_settings', plot_settings );

for n = 1:length( stems )
    col = mod( n-1, 5 ) + 1;
    row = floor((n-1)/5);
    stems{n}.center = [col*30, row*20]+20;
    stems{n}.rotation =  180;
    stems{n}.parity   = 1;
    stems{n}.stem_tag = sprintf('Helix_%s%d',...
        stems{n}.chain1(1),...
        stems{n}.resnum1(1));% this better be a unique identifier
end
% single stranded residues:
for n = 1:length( stems )
    stem_start1(n) = stems{n}.resnum1(1);
    stem_stop1 (n) = stems{n}.resnum1(end);
    stem_chain1 (n) = stems{n}.chain1(1);
    stem_start2(n) = stems{n}.resnum2(1);
    stem_stop2 (n) = stems{n}.resnum2(end);
    stem_chain2 (n) = stems{n}.chain2(1);
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
    residue.stem_tag = stems{n}.stem_tag;
    seqpos = intersect(strfind(chains,chain), find(resnum==res));
    residue.nucleotide = upper(sequence(seqpos));
    residue.linkers = {};
    setappdata( gca, res_tag, residue );
end
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
draw_dummy_linkers();
draw_dummy_base_pairs( base_pairs, canonical_pair_map )
for n = 1:length( stems )
    draw_helix( stems{n} );
end

axis off
axis equal
set(gcf,'color','white')
