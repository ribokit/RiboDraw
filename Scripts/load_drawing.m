function load_drawing( filename )
% load RiboDraw drawing from JSON drawing file.
% (C) R. Das, Stanford University, 2017
if isstruct( filename )
    loaddata = filename;
else
    assert( ischar( filename ) )
    loaddata = loadjson( filename );
end

clf; set(gca,'Position',[0 0 1 1]);
hold on
set( gca, 'xlim', loaddata.xlim );
set( gca, 'ylim', loaddata.ylim );
% Should install sequence, Residue, Helix objects, etc. into gca ('global
% data' for these axes);
datafields = fields( loaddata );
for i = 1:length( datafields )
    datafield = datafields{i};
    setappdata( gca, datafield, getfield( loaddata, datafield ) );
end
draw_dummy_linkers();
if isappdata( gca, 'base_pairs' ); draw_dummy_base_pairs( getappdata( gca, 'base_pairs' ) ); end;
draw_helices();

axis off
axis equal
set(gcf,'color','white')