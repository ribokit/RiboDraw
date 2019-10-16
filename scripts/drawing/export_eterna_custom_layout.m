function export_eterna_custom_layout()
% export_eterna_custom_layout()
%
% print out an array that can be used in JSON objectives for Eterna puzzles
%
% (C) R. Das, Stanford University 2019

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[secstruct,res_tags] = get_secstruct_from_drawing();
%fprintf( '\nCopy this secstruct into puzzle maker:\n\n %s\n\n', secstruct );
fprintf( '\nCopy this secstruct into puzzle maker:\n\n %s\n\n', strrep(strrep(secstruct,']','.'),'[','.') );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sequence = get_sequence_from_res_tags( res_tags );
fprintf( '\nCopy this sequence into puzzle maker:\n\n %s\n\n', sequence );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
coords = export_coordinates( res_tags );
N = size( coords, 1 );

fprintf( '\nAfter saving puzzle maker puzzle, edit puzzle via admin.\nPaste following into Puzzle-objective JSON:\n\n, "custom-layout":[' );
spacing = 3; % later pull this from plot_settings.spacing !
for i = 1:N
    fprintf( '[%.3f,%.3f]', coords(i,1)/spacing, coords(i,2)/spacing );
    if ( i < N ) fprintf( ', '); end;
end
fprintf( ']\n\n' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lockstring = ''; for i = 1:length(res_tags); lockstring = [lockstring,'o']; end; 
fprintf( '\nIn puzzle editor, copy this lock-string into locks:\n\n %s\n\n', lockstring );
