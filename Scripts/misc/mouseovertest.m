function mouseovertest
 
f=figure('renderer','painters');
a=axes;
 
%some animal data:
%name   speed   weight
animals={'Peregrine falcon',200.00,4;
'Cheetah',70.00,110;
'Pronghorn antelope',61.00,60;
'Lion',50.00,150;
'Thomson''s gazelle',50.00,170;
'Wildebeest',50.00,250;
'Quarter horse',47.50,1000;
'Cape hunting dog',45.00,40;
'Elk',45.00,300;
'Coyote',43.00,50;
'Gray fox',42.00,15;
'Hyena',40.00,45;
'Ostrich',40.00,200};
 
%plot the data
L=line(cell2mat(animals(:,3)),cell2mat(animals(:,2)),'marker','o','markersize',10,...
    'markerfacecolor',[.3 .6 1],'markeredgecolor',[0 0 0],'linestyle','none');
xlabel('Weight (lbs')
ylabel('Speed (mph)');
 
%apply mouse motion function
set(f,'windowbuttonmotionfcn',{@mousemove,L,animals});
 
function mousemove(src,ev,L,animals)
 
%since this is a figure callback, the first input is the figure handle:
f=src;
 
%like all callbacks, the second input, ev, isn't used. 
 
%determine which object is below the cursor:
obj=hittest(f); %<-- the important line in this demo
 
if obj==L %if over the plot...
    %get cursor coordinates in its axes:
    a=get(L,'parent');
    point=get(a,'currentpoint');
    xclick=point(1,1,1);
    yclick=point(1,2,1);
 
    %determine which point we're over:
    idx=findclosestpoint2D(xclick,yclick,L);
 
    %make a "tool tip" that displays this animal.
    xoffset=5;
    yoffset=2;
 
    delete(findobj(f,'tag','mytooltip')); %delete last tool tip
    text(animals{idx,3}+xoffset,animals{idx,2}+yoffset,animals{idx,1},...
        'backgroundcolor',[1 1 .8],'tag','mytooltip','edgecolor',[0 0 0],...
        'hittest','off');
else
    delete(findobj(f,'tag','mytooltip')); %delete last tool tip
 
end
 
 
function index=findclosestpoint2D(xclick,yclick,datasource)
%this function checks which point in the plotted line "datasource"
%is closest to the point specified by xclick/yclick. It's kind of 
%complicated, but this isn't really what this demo is about...
 
xdata=get(datasource,'xdata');
ydata=get(datasource,'ydata');
 
activegraph=get(datasource,'parent');
 
pos=getpixelposition(activegraph);
xlim=get(activegraph,'xlim');
ylim=get(activegraph,'ylim');
 
%make conversion factors, units to pixels:
xconvert=(xlim(2)-xlim(1))/pos(3);
yconvert=(ylim(2)-ylim(1))/pos(4);
 
Xclick=(xclick-xlim(1))/xconvert;
Yclick=(yclick-ylim(1))/yconvert;
 
Xdata=(xdata-xlim(1))/xconvert;
Ydata=(ydata-ylim(1))/yconvert;
 
Xdiff=Xdata-Xclick;
Ydiff=Ydata-Yclick;
 
distnce=sqrt(Xdiff.^2+Ydiff.^2);
 
index=distnce==min(distnce);
 
index=index(:); %make sure it's a column.
 
if sum(index)>1
    thispoint=find(distnce==min(distnce),1);
    index=false(size(distnce));
    index(thispoint)=true;
end