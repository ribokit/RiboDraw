function set_eterna_theme();
%
% visualize how ribodraw might look like if it
%  is displayed in Eterna.
%
% (C) R. Das, Stanford University, 2019

set_bg_color( [16,33,59]/255 );
set_line_color( 'white' );
set_symbol_color( 'white' );

plot_settings = get_plot_settings();
plot_settings.bp_spacing = plot_settings.spacing;
plot_settings.eterna_theme = 1;
plot_settings.font_size = 12;
plot_settings.show_arrows = 0;
plot_settings.show_stem_pairs = 0;
plot_settings.show_base_rope = 1;
setappdata( gca, 'plot_settings', plot_settings );

create_eterna_fill_and_ring_circles();
show_fill_and_ring_circles;
color_drawing eterna;

draw_helices(); % force redraw of everything, including base rope.
move_stuff_to_back();
fprintf( '\n Type set_default_theme() to restore the usual colors.\n' )
set_artboards;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function create_eterna_fill_and_ring_circles();
% make gray rings, and transfer any rgb_colors for text to fill colors instead. 
% save original rgb_colors in residue.original_rgb_color;
res_tags = get_res();
plot_settings = getappdata(gca,'plot_settings' );
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    if ~isfield( residue, 'fill_color' )
        if isfield( residue, 'rgb_color' )
            residue.original_rgb_color = residue.rgb_color;
            residue.fill_color = residue.rgb_color;
            residue.rgb_color = 'k';
        end
    end
    residue.ring_color = [0.7 0.7 0.7];
    setappdata( gca, res_tags{i}, residue );
end

