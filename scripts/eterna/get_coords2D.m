function coords2D = get_coords2D( drawingfile );
%  coords2D = get_coords2D();
%  coords2D = get_coords2D( drawingfile );
%
% return 2D coordinates from drawing, scaled as if ready to
%  be exported from RiboDraw to Eterna.
%
% (C) R. Das, Stanford University, 2019
if exist( 'drawingfile','var');
    load_drawing( drawingfile );
end
coords2D = export_eterna();
