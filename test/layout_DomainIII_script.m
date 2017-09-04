helices = read_helices( 'DomainIII_helices.txt' );
[sequence,resnum,chains,non_standard_residues] = get_sequence( '4ybb_DomainIII.fasta' );

clf;
hold on
t = zeros( 1, length(sequence ) );
axis( [0 200 0 200] );

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
for i = 1:length(sequence)
    j = i + 1;
    if ( j > length( sequence ) ) continue; end;
    if ( chains(j) ~= chains(i) ) continue; end;    
    res_tag_i = sprintf('Residue_%s%d',chains(i),resnum(i));
    res_tag_j = sprintf('Residue_%s%d',chains(j),resnum(j));
    linker.residue1 = res_tag_i;
    linker.residue2 = res_tag_j;
    linker.handle = plot( [0,0],[0,0],'k' ); % dummy for now -- will get redrawn below.
    % stick this linker information in the connected residues.
    residue = getappdata( gca, res_tag_i ); residue.linkers = [ residue.linkers, linker ]; setappdata( gca, res_tag_i, residue );
    residue = getappdata( gca, res_tag_j ); residue.linkers = [ residue.linkers, linker ]; setappdata( gca, res_tag_j, residue );
end
for n = 1:length( helices )
    draw_helix( helices{n} );
end


% DRAW_ARROWS = 0;
% if DRAW_ARROWS
%     % draw connectors
%     hold on;
%     in_loop = 1; prev_idx = 0;
%     for i = 1:length(t)
%         if t(i) == 0 & ~in_loop
%             start_loop = prev_idx;
%             in_loop = 1;
%         end
%         if t(i) > 0 & in_loop
%             stop_loop = i;
%             in_loop = 0;
%             arrow( get(t(start_loop),'position'), get(t(stop_loop),'position') );
%         end
%         prev_idx = i;
%     end
% end
% 



axis off
axis equal
set(gcf,'color','white')
%axis image


%axis off
%axis image


