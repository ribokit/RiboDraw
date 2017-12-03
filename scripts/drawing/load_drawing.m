function loaddata = load_drawing( filename, keep_previous_drawing, keep_drawing_axes )
% loaddata = load_drawing( filename )
% loaddata = load_drawing( filename, keep_previous_drawing, keep_drawing_axes )
%
% load RiboDraw drawing from JSON or .mat drawing file.
%
% INPUTS:
%   filename              = name of .json or .mat file with drawing
%   keep_previous drawing = [Optional] import drawing but keep 
%                              residues, linkers, etc. not covered
%                              by loaded drawing [default 0]
%   keep_drawing_axes     = [Optional] keep axes (x,y dimensions,
%                             etc.) of previous drawing without
%                             trying to equalize image
%                             axes. [default 0]
%
% OUTPUT
%   savedata = MATLAB 'drawing' data structure with all the saved info
%
% See also: IMPORT_DRAWING, SAVE_DRAWING.
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'keep_previous_drawing', 'var' ) keep_previous_drawing = 0; end;
if ~exist( 'keep_drawing_axes', 'var' )     keep_drawing_axes = 0; end;
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

tic
fprintf( 'Drawing helices...\n' );
if keep_previous_drawing;
    loaddata.plot_settings = getappdata( gca, 'plot_settings' );
    loaddata.xlim = getappdata( gca, 'xlim' );
    loaddata.ylim = getappdata( gca, 'ylim' );
    loaddata.windowposition = getappdata( gca, 'windowposition' );
else
    clf; 
    set(gca,'Position',[0 0 1 1]);
    set(gca, 'xlim', loaddata.xlim );
    set(gca, 'ylim', loaddata.ylim );
    set(gcf,'Position',loaddata.window_position)
end
hold on;

% cleanup of old data that might have been deleted in new drawing.
if keep_previous_drawing; remove_old_linkers_and_tertiary_contacts_handled_by_loaddata( loaddata ); end;

% Should install sequence, Residue, Helix objects, etc. into gca ('global
% data' for these axes);
datafields = fields( loaddata );
for i = 1:length( datafields )
    datafield = datafields{i};
    datum = getfield( loaddata, datafield );

    % copy over old handles to graphical objects like text, lines,
    % ticks, etc. -- redrawing them would take a long time!
    if isappdata( gca, datafield )
        olddatum = getappdata( gca, datafield );
        if isstruct( olddatum )
            oldfields = fields( olddatum );
            for i = 1:length( oldfields )
                field = oldfields{i};
                if ~isfield( datum, field )
                    datum = setfield( datum, field, getfield(olddatum,field) );
                end
                % special case cleanup
                if strcmp( field, 'linkers' ) & isfield( datum, field )
                    datum.linkers = unique( [olddatum.linkers, datum.linkers ] ); 
                end
                if strcmp( field, 'associated_selections' ) & isfield( datum, field )
                    datum.associated_selections = unique( [olddatum.associated_selections, datum.associated_selections ] ); 
                end
            end
        end
        loaddata = setfield( loaddata, datafield, datum );
    end
    setappdata( gca, datafield, datum );    
end
cleanup_associated_residues();
cleanup_stray_linkers();
cleanup_domains();
cleanup_segids();
convert_problem_helices_to_domains; % happens when helices get disconnected across multiple input domains.
draw_helices( get_helices( loaddata ) );
move_stuff_to_back();

axis off
if ~keep_drawing_axes
    set_nice_axes();
end
set(gcf,'color','white')

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function remove_old_linkers_and_tertiary_contacts_handled_by_loaddata( loaddata )
% copies code from get_drawing.

% which residues are being handled by imported drawing (loaddata)?
slice_res_tags = get_tags( 'Residue_','',fields(loaddata) );

% are any elements of old drawing handled by imported drawing  but are now
% gone from imported drawing?
% linkers
linker_tags = get_tags( 'Linker' );
for i = 1:length( linker_tags )
    tag = linker_tags{i};
    linker = getappdata( gca, tag );
    if ~any(strcmp(linker.residue1, slice_res_tags ) ) continue; end;
    if ~any(strcmp(linker.residue2, slice_res_tags ) ) continue; end;
    if isfield( linker, 'tertiary_contact' ) continue; end; % handle this case below.
    if ~isfield( loaddata, tag ); 
        fprintf( 'Removing %s from old drawing as it is handled by imported drawing\n', tag );
        delete_linker( linker );
    end;
end

% selections
selection_tags = get_tags( 'Selection', 'domain' );
for i = 1:length( selection_tags )
    tag = selection_tags{i};
    selection = getappdata( gca, tag );
    selection_res_tags = unique(selection.associated_residues);
    if length(intersect( selection_res_tags, slice_res_tags )) < length( selection_res_tags ) continue; end;
    if ~isfield( loaddata, tag ); 
        fprintf( 'Removing %s from old drawing as it is handled by imported drawing\n', tag );
        delete_domain( tag );
    end;
end

% tertiary_contact_residues
tertiary_contact_tags = get_tags( 'TertiaryContact' );
for i = 1:length( tertiary_contact_tags )
    tag = tertiary_contact_tags{i};
    tertiary_contact = getappdata( gca, tag );

    contact_ok = 1;
    tertiary_contact_res_tags = unique(tertiary_contact.associated_residues1);
    if length(intersect( tertiary_contact_res_tags, slice_res_tags )) < length( tertiary_contact_res_tags ); contact_ok = 0; end;
    tertiary_contact_res_tags = unique(tertiary_contact.associated_residues2);
    if length(intersect( tertiary_contact_res_tags, slice_res_tags )) < length( tertiary_contact_res_tags ); contact_ok = 0; end;
    if ( ~contact_ok ) continue; end;
    if ~isfield( loaddata, tag );
        fprintf( 'Removing %s from old drawing as it is handled by imported drawing\n', tag );
        delete_tertiary_contact( tag );
    end;
end

