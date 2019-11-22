function export_eterna( selection, full_sequence, full_secstruct, full_locks, full_IUPAC, full_structure_constrained_bases );
% export_eterna()
% export_eterna( selection )
% export_eterna( selection, full_sequence, full_secstruct, full_locks, full_IUPAC, full_structure_constrained_bases )
%
% Print out info that can be pasted into DRUPAL edit mode of Eterna puzzles
% Updated to enable sub-puzzles of ribosome with custom-layout, lock
% strings, etc.
%
% (OPTIONAL) INPUTS 
%  selection = optional: domain name [Default: 'all']
%  full_sequence  = sequence (string) of full-length RNA, assuming this is a
%                   subdomain of a single sequence whose original numbering
%                   starts with 1. Enables cross-check!
%  full_secstruct = Secondary structure string of full-length RNA, enabling
%                    cross-check.
%  full_locks     = locks in 'oooxxoo..' format of full-length RNA.
%  full_IUPAC     = IUPAC string of full-length RNA
%  full_structure_constrained_bases = array of indices of first,last of segments of 
%                     'do care' bases (must be even in  length)
%
% (C) R. Das, Stanford University 2019

if ~exist( 'selection' ) | isempty( selection ); selection = 'all'; end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[secstruct,res_tags] = get_secstruct_from_drawing(selection);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[sequence,resnum] = get_sequence_from_res_tags( res_tags );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
coords = get_coordinates_for_eterna( res_tags );
locks = repmat('o',1,length(res_tags) );
IUPAC = repmat('N',1,length(res_tags) );
do_care = [1:length(res_tags)];

if exist( 'full_sequence','var' ); check_sequence( sequence, resnum, full_sequence ); end;
if exist( 'full_secstruct','var' ); check_sequence( secstruct, resnum, full_secstruct); end;
if exist( 'full_locks','var' ) locks = full_locks( resnum ); end;
if exist( 'full_locks','var' ) IUPAC = full_IUPAC( resnum ); end;
if exist( 'full_structure_constrained_bases','var') do_care = get_do_care(full_structure_constrained_bases,length(full_sequence)); end;

[sequence, secstruct, coords, resnum, locks, IUPAC, do_care] = add_connectors_across_chainbreaks( sequence, secstruct, coords, resnum, locks, IUPAC, do_care, res_tags );

%fprintf( '\nCopy this secstruct into puzzle maker:\n\n %s\n\n', secstruct );
fprintf( '\nCopy this secstruct into puzzle maker:\n\n %s\n\n', strrep(strrep(secstruct,']','.'),'[','.') );
fprintf( '\nCopy this sequence into puzzle maker:\n\n %s\n\n', sequence );
fprintf( '\nAfter saving puzzle maker puzzle, edit puzzle via admin.\nPaste following into Puzzle-objective JSON:\n\n');
fprintf( ',"custom-numbering":"%s"\n',strrep(ribodraw_make_tag_with_dashes(resnum),'NaN','null') )
if length(strfind( IUPAC,'N'))<length(IUPAC)
    fprintf( ',"IUPAC":"%s"\n',IUPAC );
end
if any( do_care == 0 )
    structure_constrained_bases = get_structure_constrained_bases( do_care );
    fprintf( ',"structure_constrained_bases":[%d',structure_constrained_bases(1))
    for i = structure_constrained_bases(2:end); fprintf(',%d',i);end;
    fprintf( ']\n' );
end
fprintf( ',"custom-layout":[' );
plot_settings = get_plot_settings();
N = size( coords, 1 );
for i = 1:N
    if any(isnan( coords(i,:) )  )
        fprintf( '[null,null]' );
    else
        fprintf( '[%d,%d]', coords(i,1), coords(i,2) );
    end
    if ( i < N ) fprintf( ','); end;
    if ( mod(i,200) == 0 ) fprintf( '\n' ); end;
end
fprintf( ']\n\n' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf( '\nIn puzzle editor, copy this lock-string into locks:\n\n %s\n\n', locks );


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
function [sequence_out, secstruct_out, coords_out, resnum_out, locks_out, IUPAC_out, do_care_out] = ...
    add_connectors_across_chainbreaks( sequence, secstruct, coords, resnum, locks, IUPAC, do_care, res_tags );
sequence_spacer = 'AAAA';
secstruct_spacer = '....';
coords_spacer = ones(4,2)*NaN;
resnum_spacer = ones(4,1)*NaN;
locks_spacer = 'oooo';
IUPAC_spacer = 'NNNN';
do_care_spacer = ones(4,1);

sequence_out = '';
secstruct_out = '';
coords_out = [];
resnum_out = [];
locks_out = '';
IUPAC_out = '';
do_care_out = [];

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
                resnum_out = [ resnum_out; resnum_spacer ];
                locks_out = [ locks_out, locks_spacer ];
                IUPAC_out = [ IUPAC_out, IUPAC_spacer ];
                last_do_care = 1; if length( do_care_out ) > 0; last_do_care = do_care_out(end); end;
                do_care_out = [ do_care_out; do_care_spacer * last_do_care ];
            else
                fprintf( 'Adjoining %s and %s\n', prev_res_tag, res_tags{i} );
            end
        end
    end
    sequence_out = [sequence_out, sequence(i) ];
    secstruct_out = [secstruct_out, secstruct(i) ];
    coords_out = [coords_out; coords(i,:) ];
    resnum_out = [resnum_out; resnum(i)];
    locks_out = [locks_out, locks(i)];
    IUPAC_out = [IUPAC_out, IUPAC(i)];
    do_care_out = [do_care_out; do_care(i)];
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
%coords = coords - round(mean( coords ));


N = size( coords, 1 );
for i = 1:N
    if ( abs( coords(i,1) - round(coords(i,1)) ) > 0.001  | ...
            abs( coords(i,2) - round(coords(i,2)) ) > 0.001  )
        fprintf( 'Warning! coords at %s  (index %d) will be rounded:   %f %f\n',res_tags{i}, i, coords(i,:) );
        coords(i,:) = round( coords(i,:) );
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function check_sequence( sequence, resnum, full_sequence );
for i = 1:length(resnum);
    if( full_sequence(resnum) ~= sequence( i ) );
        fprintf( 'Warning! Sequence mismatch at resnum %d. Ribodraw: %s. Full_sequence: %s\n',resnum,sequence(i),full_sequence(resnum));
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function x_out = slice_array(x,resnum);
% x_out = [];
% for i = x;
%     n = find( i == resnum );
%     if ~isempty( n )
%         x_out = [ x_out, n ];
%     end
% end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function do_care = get_do_care( x, N);
% x = [a,b,c,d,e,f,...] is read out as a-b, c-d, e-f, ...
assert( mod(length( x ) ,2) == 0 );
do_care = zeros(1,N );
for i = 1:length(x)/2
    do_care( [x(2*i-1):x(2*i)] ) = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  structure_constrained_bases = get_structure_constrained_bases( do_care );
structure_constrained_bases = [];
do_care_idx_range = [];
for i =1: length(do_care)
    if do_care(i)
        do_care_idx_range = [do_care_idx_range, i ];
    else
        structure_constrained_bases = [structure_constrained_bases, min(do_care_idx_range), max( do_care_idx_range) ];
        do_care_idx_range = [];
    end
end
if ~isempty( do_care_idx_range )
    structure_constrained_bases = [structure_constrained_bases, min(do_care_idx_range), max( do_care_idx_range) ];
end