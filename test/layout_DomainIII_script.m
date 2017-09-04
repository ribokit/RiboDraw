helices = read_helices( 'DomainIII_helices.txt' );
[sequence,resnum,chains,non_standard_residues] = get_sequence( '4ybb_DomainIII.fasta' );

clf;
hold on
t = zeros( 1, length(sequence ) );
axis( [0 200 0 200] );

% extremely dumb initialization:
for n = 1:length( helices )
    col = mod( n-1, 5 ) + 1;
    row = floor((n-1)/5);
    helices{n}.center = [col*30, row*20]+20;
    helices{n}.rotation =  180;
    strand1 = ''; strand2 = '';
    helix = helices{n};
    N = length( helix.resnum1 );
    for k = 1:N
        seqpos1 = intersect(strfind(chains,helix.chain1(k)), find(resnum==helix.resnum1(k)));
        seqpos2 = intersect(strfind(chains,helix.chain2(N-k+1)), find(resnum==helix.resnum2(N-k+1)));
        strand1 = [strand1, sequence( seqpos1 ) ];
        strand2 = [strand2, sequence( seqpos2 ) ];
    end
    helices{n}.strand1 = strand1;
    helices{n}.strand2 = strand2;
end
for n = 1:length( helices )
    setappdata( gca, sprintf('Helix%d',helices{n}.resnum1(1)), draw_helix( helices{n} ) );
end

DRAW_ARROWS = 0;
if DRAW_ARROWS
    % draw connectors
    hold on;
    in_loop = 1; prev_idx = 0;
    for i = 1:length(t)
        if t(i) == 0 & ~in_loop
            start_loop = prev_idx;
            in_loop = 1;
        end
        if t(i) > 0 & in_loop
            stop_loop = i;
            in_loop = 0;
            arrow( get(t(start_loop),'position'), get(t(stop_loop),'position') );
        end
        prev_idx = i;
    end
end




axis off
axis equal
set(gcf,'color','white')
%axis image


%axis off
%axis image


