function export_eterna_custom_layout()
% export_eterna_custom_layout()
%
% print out an array that can be used in JSON objectives for Eterna puzzles

coords = export_coordinates();
N = size( coords, 1 );

fprintf( '\n\n paste following into Puzzle-objective JSON:\n\n, "custom-layout":[' );
spacing = 3; % later pull this from plot_settings.spacing !
for i = 1:N
    fprintf( '[%f,%f]', coords(i,1)/spacing, coords(i,2)/spacing );
    if ( i < N ) fprintf( ', '); end;
end
fprintf( ']\n\n' );

