% eventually need to move these loops into separate functions.
helices = read_stems( '4ybb_DIII_stems.txt' );
[sequence,resnum,chains,non_standard_residues] = get_sequence( '4ybb_DomainIII.fasta' );
setappdata( gca, 'sequence', sequence );
setappdata( gca, 'resnum', resnum );
setappdata( gca, 'chains', chains );
setappdata( gca, 'non_standard_residues', non_standard_residues );
%base_pairs = read_base_pairs( '4ybb_DIII_base_pairs.txt' ); % includes noncanonical pairs.
%setappdata( gca, 'base_pairs', base_pairs );

clf; set(gca,'Position',[0 0 1 1]);
hold on
t = zeros( 1, length(sequence ) );
axis( [0 200 0 200] );

plot_settings.fontsize   =10;
plot_settings.spacing    = 3;
plot_settings.bp_spacing = 6;
setappdata( gca, 'plot_settings', plot_settings );

for n = 1:length( helices )
    col = mod( n-1, 5 ) + 1;
    row = floor((n-1)/5);
    helices{n}.center = [col*30, row*20]+20;
    helices{n}.rotation =  180;
    helices{n}.parity   = 1;
    helices{n}.helix_tag = sprintf('Helix_%s%d',...
        helices{n}.chain1(1),...
        helices{n}.resnum1(1));% this better be a unique identifier
end
% single stranded residues:
for n = 1:length( helices )
    helix_start1(n) = helices{n}.resnum1(1);
    helix_stop1 (n) = helices{n}.resnum1(end);
    helix_chain1 (n) = helices{n}.chain1(1);
    helix_start2(n) = helices{n}.resnum2(1);
    helix_stop2 (n) = helices{n}.resnum2(end);
    helix_chain2 (n) = helices{n}.chain2(1);
    helices{n}.associated_residues = {};
end
for i = 1:length(sequence)
    % find which helix is closest to the residue.
    chain = chains(i);
    res   = resnum(i);
    res_tag = sprintf('Residue_%s%d',chain,res);
    dists1 = Inf * ones( 1, length( helices ) );
    dists2 = Inf * ones( 1, length( helices ) );
    m = strfind( helix_chain1, chain );
    dists1(m) = min( abs( helix_start1(m) - res ), abs( abs(helix_stop1(m) - res) ) ); 
    m = strfind( helix_chain2, chain );
    dists2(m) = min( abs( helix_start2(m) - res ), abs( abs(helix_stop2(m) - res) ) ); 
    dists = min( dists1, dists2 );
    [~,n] = min( dists );
    helices{n}.associated_residues = [ helices{n}.associated_residues, res_tag ];
    residue.chain = chain;
    residue.resnum = res;
    residue.helix_tag = helices{n}.helix_tag;
    seqpos = intersect(strfind(chains,chain), find(resnum==res));
    residue.nucleotide = upper(sequence(seqpos));
    residue.linkers = {};
    setappdata( gca, res_tag, residue );
end
draw_dummy_linkers();
draw_dummy_base_pairs( base_pairs )
for n = 1:length( helices )
    draw_helix( helices{n} );
end

axis off
axis equal
set(gcf,'color','white')
