function export_eterna_custom_layout()
% export_eterna_custom_layout()
%
% print out an array that can be used in JSON objectives for Eterna puzzles
%
% (C) R. Das, Stanford University 2019

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[secstruct,res_tags] = get_secstruct_from_drawing();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sequence = get_sequence_from_res_tags( res_tags );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
coords = export_coordinates( res_tags );
lockstring = ''; for i = 1:length(res_tags); lockstring = [lockstring,'o']; end; 

[sequence, secstruct, coords] = add_connectors_across_chainbreaks( sequence, secstruct, coords, res_tags );

%fprintf( '\nCopy this secstruct into puzzle maker:\n\n %s\n\n', secstruct );
fprintf( '\nCopy this secstruct into puzzle maker:\n\n %s\n\n', strrep(strrep(secstruct,']','.'),'[','.') );
fprintf( '\nCopy this sequence into puzzle maker:\n\n %s\n\n', sequence );
fprintf( '\nAfter saving puzzle maker puzzle, edit puzzle via admin.\nPaste following into Puzzle-objective JSON:\n\n, "custom-layout":[' );
spacing = 3; % later pull this from plot_settings.spacing !
N = size( coords, 1 );
for i = 1:N
    if any(isnan( coords(i,:) )  )
        fprintf( '[null,null]' );
    else
        fprintf( '[%.3f,%.3f]', coords(i,1)/spacing, coords(i,2)/spacing );
    end
    if ( i < N ) fprintf( ', '); end;
end
fprintf( ']\n\n' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf( '\nIn puzzle editor, copy this lock-string into locks:\n\n %s\n\n', lockstring );



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sequence_out, secstruct_out, coords_out] = add_connectors_across_chainbreaks( sequence, secstruct, coords, res_tags );
sequence_spacer = 'AAAA';
secstruct_spacer = '....';
coords_spacer = ones(4,2)*NaN;

sequence_out = '';
secstruct_out = '';
coords_out = [];
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    if ( i > 1 )
        if ( prev_chain ~= residue.chain ) | ( prev_segid ~= residue.segid ) | ...
                ( prev_resnum ~= residue.resnum-1 )
            if secstruct(i-1) == '(' && secstruct(i) == ')'
                fprintf( 'Adding spacer %s between %s and %s\n', sequence_spacer, prev_res_tag, res_tags{i} );
                sequence_out  = [ sequence_out , sequence_spacer ];
                secstruct_out = [ secstruct_out, secstruct_spacer ];
                coords_out = [ coords_out; coords_spacer ];
            else
                fprintf( 'Adjoining %s and %s\n', prev_res_tag, res_tags{i} );
            end
        end
    end
    sequence_out = [sequence_out, sequence(i) ];
    secstruct_out = [secstruct_out, secstruct(i) ];
    coords_out = [coords_out; coords(i,:) ];
    prev_chain = residue.chain;
    prev_segid = residue.segid;
    prev_resnum = residue.resnum;
    prev_res_tag = res_tags{i};
end




