function coords = export_eterna( selection );
% export_eterna()
% export_eterna( selection )
%
% print out an array that can be used in JSON objectives for Eterna puzzles
%
% (C) R. Das, Stanford University 2019

if ~exist( 'selection' ) selection = 'all'; end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[secstruct,res_tags] = get_secstruct_from_drawing(selection);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sequence = get_sequence_from_res_tags( res_tags );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
coords = get_coordinates_for_eterna( res_tags );
lockstring = ''; for i = 1:length(res_tags); lockstring = [lockstring,'o']; end; 

[sequence, secstruct, coords] = add_connectors_across_chainbreaks( sequence, secstruct, coords, res_tags );

%fprintf( '\nCopy this secstruct into puzzle maker:\n\n %s\n\n', secstruct );
fprintf( '\nCopy this secstruct into puzzle maker:\n\n %s\n\n', strrep(strrep(secstruct,']','.'),'[','.') );
fprintf( '\nCopy this sequence into puzzle maker:\n\n %s\n\n', sequence );
fprintf( '\nAfter saving puzzle maker puzzle, edit puzzle via admin.\nPaste following into Puzzle-objective JSON:\n\n, "custom-layout":[' );
plot_settings = get_plot_settings();
N = size( coords, 1 );
for i = 1:N
    if any(isnan( coords(i,:) )  )
        fprintf( '[null,null]' );
    else        
        fprintf( '[%d,%d]', coords(i,1), coords(i,2) );
    end
    if ( i < N ) fprintf( ', '); end;
    if ( mod(i,200) == 0 ) fprintf( '\n' ); end;
end
fprintf( ']\n\n' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf( '\nIn puzzle editor, copy this lock-string into locks:\n\n %s\n\n', lockstring );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pseudoknot_idx = strfind(secstruct,'[');
if ~isempty(pseudoknot_idx )
    fprintf( '\nWARNING! WARNING! Found a pseudoknot! Will be ignored in secstruct!!\n' )
    helix_tag = strrep(res_tags{ pseudoknot_idx(1) },'Residue_','Helix_');
    if isappdata( gca, helix_tag )
        fprintf( '\nConsider converting pseudknot to a long range stem with the command:\n\n' );
        fprintf( ' convert_helix_to_long_range_stem_pairs( \''%s\'');\n\n', helix_tag );
    end
end


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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  coords = get_coordinates_for_eterna( res_tags )
coords = [];
for i = 1:length( res_tags )
    res = getappdata( gca, res_tags{i} );
    % reverse MATLAB's y-axis since every other program does that.
    coords(i,:) = [ res.plot_pos(1), -res.plot_pos(2) ];
end
plot_settings = get_plot_settings();
coords = coords * (4 / plot_settings.spacing);  % grid spacing.

% center coordinates. Eterna will re-center.
coords = coords - round(mean( coords ));


N = size( coords, 1 );
for i = 1:N
    if ( abs( coords(i,1) - round(coords(i,1) ) > 0.001 ) || ...
            abs( coords(i,2) - round(coords(i,2) ) > 0.001 ) )
        fprintf( 'Warning! coords at %s  (index %d) will be rounded:   %f %f\n',res_tags{i}, i, coords(i,:) );
    end
end
