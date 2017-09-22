function loaddata = load_drawing( filename, keep_previous_drawing )
% load RiboDraw drawing from JSON drawing file.
% (C) R. Das, Stanford University, 2017
if ~exist( 'keep_previous_drawing', 'var' ) keep_previous_drawing = 0; end;
if isstruct( filename )
    loaddata = filename;
else
    assert( ischar( filename ) )
    loaddata = loadjson( filename );
end
if ~keep_previous_drawing; 
    clf ; 
    set(gca,'Position',[0 0 1 1]);
    hold on;
end
set( gca, 'xlim', loaddata.xlim );
set( gca, 'ylim', loaddata.ylim );
% Should install sequence, Residue, Helix objects, etc. into gca ('global
% data' for these axes);
datafields = fields( loaddata );
for i = 1:length( datafields )
    datafield = datafields{i};
    setappdata( gca, datafield, getfield( loaddata, datafield ) );
end
draw_dummy_ticks();
draw_helices( get_helices( loaddata ) );

axis off
axis equal
set(gcf,'color','white')
if isfield( 'loaddata', 'window_position' )
    set(gcf,'Position',loaddata.window_position)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function helices = get_helices( loaddata )
helices = {};
objnames = fields( loaddata );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Helix_' ) );
        helices = [helices,getfield(loaddata,objnames{n})];
    end
end