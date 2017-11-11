function loaddata = load_drawing( filename, keep_previous_drawing )
% load RiboDraw drawing from JSON drawing file.
% (C) R. Das, Stanford University, 2017
if ~exist( 'keep_previous_drawing', 'var' ) keep_previous_drawing = 0; end;
if isstruct( filename )
    loaddata = filename;
else
    assert( ischar( filename ) )
    tic
    if length(filename) > 4 & strcmp( filename( end-3:end ), '.mat' )
        fprintf( 'Reading MATLAB workspace  %s\n', filename );
        drawing = load( filename, 'drawing' );
        loaddata = drawing.drawing;
    else
        fprintf( 'Reading JSON: %s\n',filename );
        loaddata = loadjson( filename );
    end
    toc
end
if ~keep_previous_drawing; 
    clf ; 
    set(gca,'Position',[0 0 1 1]);
    hold on;
end

tic
fprintf( 'Drawing helices...\n' );
set( gca, 'xlim', loaddata.xlim );
set( gca, 'ylim', loaddata.ylim );


% Should install sequence, Residue, Helix objects, etc. into gca ('global
% data' for these axes);
datafields = fields( loaddata );
for i = 1:length( datafields )
    datafield = datafields{i};
    datum = getfield( loaddata, datafield );

    if isappdata( gca, datafield )
        % copy over old handles to graphical objects like text, lines,
        % ticks, etc.
        olddatum = getappdata( gca, datafield );
        if isstruct( olddatum )
            oldfields = fields( olddatum );
            for i = 1:length( oldfields )
                field = oldfields{i};
                if ~isfield( datum, field )
                    datum = setfield( datum, field, getfield(olddatum,field) );
                end
                if strcmp( field, 'linkers' ) & isfield( datum, field )
                    % special case. 
                    datum.linkers = unique( [olddatum.linkers, datum.linkers ] ); 
                end
            end
        end
        loaddata = setfield( loaddata, datafield, datum );
    end
    setappdata( gca, datafield, datum );    
end
cleanup_associated_residues();
cleanup_domains();
cleanup_segids();
convert_problem_helices_to_domains; % happens when helices get disconnected across multiple input domains.
draw_helices(); % get_helices( loaddata ) );
move_stuff_to_back();

axis off
axis image
axlim = axis();
axis normal
axis( axlim );

set(gcf,'color','white')
if isfield( loaddata, 'window_position' )
    set(gcf,'Position',loaddata.window_position)
end

set_fontsize( loaddata.plot_settings.fontsize );
setup_zoom();
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function helices = get_helices( loaddata )
helices = {};
objnames = fields( loaddata );
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Helix_' ) );
        helices = [helices,getfield(loaddata,objnames{n})];
    end
end