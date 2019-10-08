function export_eterna_custom_layout()
% export_eterna_custom_layout()
%
% print out an array that can be used in JSON objectives for Eterna puzzles
%
% (C) R. Das, Stanford University 2019

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
secstruct = get_secstruct_from_drawing();
fprintf( '\nCopy this secstruct into puzzle maker:\n\n %s\n\n', secstruct );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sequence = get_sequence();
fprintf( '\nCopy this sequence into puzzle maker:\n\n %s\n\n', sequence );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
coords = export_coordinates();
N = size( coords, 1 );

fprintf( '\nAfter saving puzzle maker puzzle, edit puzzle via admin.\nPaste following into Puzzle-objective JSON:\n\n, "custom-layout":[' );
spacing = 3; % later pull this from plot_settings.spacing !
for i = 1:N
    fprintf( '[%f,%f]', coords(i,1)/spacing, coords(i,2)/spacing );
    if ( i < N ) fprintf( ', '); end;
end
fprintf( ']\n\n' );

