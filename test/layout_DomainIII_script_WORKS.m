helices = read_helices( 'DomainIII_helices.txt' );

[sequence,resnum,chains,non_standard_residues] = get_sequence( '4ybb_DomainIII.fasta' );

fontsize = 8;
spacing = 3;
bp_spacing = 6;
clf;
hold on
t = zeros( 1, length(sequence ) );
for n = 1:length( helices )
    helix = helices{n};
    N = length( helix.resnum1 );
    % extremely dumb initialization:
    col = mod( n-1, 5 ) + 1;
    row = floor((n-1)/5);
    helix_center = [col*30, row*20];
    for k = 1:N
        seqpos1 = intersect(strfind(chains,helix.chain1(k)), find(resnum==helix.resnum1(k)));
        seqpos2 = intersect(strfind(chains,helix.chain2(N-k+1)), find(resnum==helix.resnum2(N-k+1)));
        pos1 = [helix_center(1) + spacing*(k-1-(N-1)/2), ...
            helix_center(2) + 0];
        t( seqpos1 ) = text( ...
            pos1(1), pos1(2),...
            upper( sequence( seqpos1 ) ),...
            'fontsize', fontsize, 'fontname','helvetica','horizontalalign','center','verticalalign','middle');        
        pos2 = [helix_center(1) + spacing*(k-1-(N-1)/2), ...
            helix_center(2) + bp_spacing ];
        t( seqpos2 ) = text( ...
            pos2(1), pos2(2), ...
            upper( sequence( seqpos2 ) ),...
            'fontsize', fontsize, 'fontname','helvetica','horizontalalign','center','verticalalign','middle');

        l( n ) = text( helix_center(1), helix_center(2) + bp_spacing*1.2, helix.name,...
                       'fontsize', fontsize*1.5, 'fontname','helvetica','horizontalalign','center','verticalalign','bottom');        
        bp = [sequence( seqpos1 ), sequence( seqpos2 )];
        switch bp
            case {'au','ua','gc','cg' }
                bp_pos1 = pos1 + [0 bp_spacing/3];
                bp_pos2 = pos2 + [0 -bp_spacing/3];
                plot( [bp_pos1(1),bp_pos2(1)],[bp_pos1(2),bp_pos2(2)],'k-','linewidth',1.5); hold on;
            case {'gu','ug'}
                bp_pos = (pos1+pos2)/2;
                rectangle( 'position',...
                    [bp_pos(1)-bp_spacing/10, bp_pos(2)-bp_spacing/10,...
                    bp_spacing*2/10, bp_spacing*2/10],...
                    'edgecolor','k','facecolor','k','curvature',[1 1]);
        end
        
    end
end

% draw connectors
hold on; pause;
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
        pause;




axis( [0 200 0 200] );
axis off
set(gcf,'color','white')
%axis image


%axis off
%axis image


