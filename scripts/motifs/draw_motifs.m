function draw_motifs( motifs );
% draw_motifs( motifs );
% draw_motifs( motif );
% draw_motifs( motif_string );
%
%  Draws motifs as rounded rectangles. Assumes order of residues
%    tracks what is in Rosetta core::scoring::rna::RNA_Motif function.
%
%  This function is in charge of drawing the initial
%   graphics if they don't exist, or revising them if
%   they already do exist.
%
% INPUT:
%  motifs = cell of tag strings or motif objects, or a
%                     single one of those tag strings or motif objects
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'motifs', 'var' ); motifs = get_tags( 'Motif' ); end
if ~iscell( motifs ) & ischar( motifs ); motifs = { motifs }; end

plot_settings = getappdata( gca, 'plot_settings' );

[rna_motif_residue_sets, rna_motif_colors, rna_motif_layer_levels ] = get_rna_motif_info();

spacing = plot_settings.spacing;
for i = 1:length( motifs )
    motif_tag = motifs{i};
    if ~isappdata( gca, motif_tag ); fprintf( 'Problem with %s\n', motif_tag ); continue; end; % some cleanup
    motif = getappdata( gca, motif_tag );
    motif = draw_motif( motif, plot_settings, rna_motif_residue_sets, rna_motif_colors, rna_motif_layer_levels );
end

%%%%%%%%%%%%
function motif = draw_motif( motif, plot_settings, rna_motif_residue_sets, rna_motif_colors, rna_motif_layer_levels )

% input is motif object.
motif_residue_sets = rna_motif_residue_sets( motif.motif_type );
if length( motif_residue_sets ) == 0; motif_residue_sets{1} = [1:length(motif.associated_residues)]; end;
num_motifs = length( motif_residue_sets );
if ~isfield( plot_settings, 'show_motifs' ) || plot_settings.show_motifs == 0; num_motifs = 0; end; 
motif = draw_highlight_box_handles( motif, num_motifs );
motif = draw_linker_handle( motif, motif_residue_sets );

for n = 1:num_motifs
    set( motif.highlight_box_handles{n}, 'facecolor', pymol_RGB( rna_motif_colors( motif.motif_type) ) );
    set( motif.highlight_box_handles{n}, 'position', get_box_pos( motif.associated_residues( motif_residue_sets{n} ), plot_settings ) );
    for n = 1:length( motif.highlight_box_handles )
        setappdata( motif.highlight_box_handles{n}, 'layer_level', rna_motif_layer_levels( motif.motif_type ) ); 
    end
end
     %[ motif.motif_type, rna_motif_colors( motif.motif_type) ]


%%%%%%%%%%%%%%%%%%%%%
function motif = draw_highlight_box_handles( motif, num_handles );
% adjust number of rounded rectangle graphics objects associated with motif
%   to match the number needed. Create or delete objects as necessary, and
%   if that occurs, update motif object in gca 'namespace'.
if ~exist( 'num_handles', 'var' ) num_handles = 1 ; end;
if ~isfield( motif, 'highlight_box_handles' ) motif.highlight_box_handles = {}; end;

original_handles = motif.highlight_box_handles;
for i = (length(  motif.highlight_box_handles )+1) :num_handles
    motif.highlight_box_handles{i} = rectangle( 'Position',...
        [0, 0,0,0],'curvature',[0.5 0.5],'edgecolor','none','facecolor',[0.5 0.5 1],'linewidth',1,'clipping','off' );
end
for i = (num_handles+1):length(  motif.highlight_box_handles )
    h = motif.highlight_box_handles{i};
    if isvalid( h ) delete(h); end;
end
motif.highlight_box_handles = motif.highlight_box_handles(1:num_handles);
    
if length( original_handles ) ~= length( motif.highlight_box_handles )
    if ( num_handles == 0 && isfield( motif, 'highlight_box_handles') ) motif = rmfield( motif, 'highlight_box_handles' ); end;
    setappdata( gca, motif.motif_tag, motif );
end


%%%%%%%%%%%%%%%%%%%%%
function motif = draw_linker_handle( motif, motif_residue_sets );

% if no rounded rectangles, no linkers either.
if ~isfield( motif, 'highlight_box_handles' ) 
    if isfield( motif, 'linker_tag' ); draw_linker( motif.linker_tag ); end; % will wipe it out
    return; 
end; 
if length( motif_residue_sets ) < 2; return; end;
assert( length( motif_residue_sets ) == 2 );
tags = get_tags( 'Linker' );
motif_residues{1} = motif.associated_residues( motif_residue_sets{1} );
motif_residues{2} = motif.associated_residues( motif_residue_sets{2} );
for i = 1:length( tags )
    linker = gd( tags{i} );
    if strcmp( linker.type, 'arrow' ) continue; end;
    if ( ( any(strcmp( linker.residue1, motif_residues{1} ) ) && ...
            any(strcmp( linker.residue2, motif_residues{2} ) ) ) || ...
         ( any(strcmp( linker.residue1, motif_residues{2} ) ) && ...
            any(strcmp( linker.residue2, motif_residues{1} ) ) ) )
        motif.linker_tag = linker.linker_tag;
        % fprintf( [motif.motif_tag, ' ', motif.linker_tag, '\n'] );
        setappdata( gca, motif.motif_tag, motif );

        linker.motif_tag = motif.motif_tag;
        setappdata( gca, linker.linker_tag, linker );
        draw_linker( linker );
        break;
    end
end
    
%%%%%%%%%%%%%%%%%%%%%
function box_pos = get_box_pos( res_tags, plot_settings ) 
[minpos, maxpos ] = get_minpos_maxpos( res_tags );  
if length( minpos ) == 0; box_pos = [0,0,0,0];return;end;
spacing = 0.5 * plot_settings.spacing;
box_pos = [ minpos(1)-spacing, minpos(2)-spacing, ...
    maxpos(1) - minpos(1)+2*spacing, maxpos(2) - minpos(2)+2*spacing ];
    


