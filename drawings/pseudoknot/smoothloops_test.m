load 1l2x_coords_bpspacing3.mat % coords variable
clf
set(figure(2),'position',[   184   649   223   283 ]);
set(gcf, 'PaperPositionMode','auto','color','white');

N = size( coords, 1 );
t = [1:0.1:N];
interp_method = 'spline';
x = interp1( 1:N, coords(:,1), t, interp_method );
y = interp1( 1:N, coords(:,2), t, interp_method );
plot( x, y, '-','linew',6,'color',[1,1,1]*0.7);
hold on
plot( x, y, '-','linew',4,'color',[1,1,1]*0.9);
sequence = 'ggcgcggcaccguccgcggaacaaacgg'
for i = 1:N
    switch upper(sequence(i))
        case 'A'
            fill_color = [0.9 0.8 0];
        case 'C'
            fill_color = [0 0.5 0];
        case 'G'
            fill_color = [0.8 0 0];
        case 'U'
            fill_color = hex2rgb('#3193D1');
    end
    plot( coords(i,1), coords(i,2),'o','color',[0.7 0.7 0.7],'linew',1,'markerfacecolor',[0.9 0.9 0.9],'markersize',20)
    plot( coords(i,1), coords(i,2),'o','color',[0.7 0.7 0.7],'linew',1,'markerfacecolor',fill_color,'markersize',16)
    text(  coords(i,1), coords(i,2), upper(sequence(i)),'horizontalalign','center','verticalalign','middle','fontweight','bold','fontsize',15);
end

axis image
axis off
set(gca,'ydir','reverse')
set(gcf,'color',[0.1 0.1 0.25] );

