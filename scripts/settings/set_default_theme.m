function set_default_theme();
%
% for fun, visualize how ribodraw might look like if it
%  followed eterna_style_guide_v3.pdf 
%
% (C) R. Das, Stanford University, 2019

set_bg_color( 'white' );
set_line_color( 'k' );
set_symbol_color( 'k' );

plot_settings = get_plot_settings();
plot_settings.bp_spacing = 2*plot_settings.spacing;
if isfield( plot_settings, 'eterna_theme' ); plot_settings = rmfield( plot_settings, 'eterna_theme' );end;
plot_settings.show_arrows = 1;
plot_settings.show_stem_pairs = 1;
plot_settings.show_base_rope = 0;
setappdata( gca, 'plot_settings', plot_settings );

restore_rgb_colors();
hide_fill_and_ring_circles;

draw_helices(); % force redraw of everything, including base rope.
move_stuff_to_back();
set_artboards;

function restore_rgb_colors();
% Remove gray rings, and transfer any fill colors or original rgb colors into text color. 
res_tags = get_res();
plot_settings = getappdata(gca,'plot_settings' );
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    if isfield( residue, 'original_rgb_color' )
        residue.rgb_color = residue.original_rgb_color;
    elseif isfield( residue, 'fill_color' )
        residue.rgb_color = residue.fill_color;
    end
    rmvars =  {'original_rgb_color','fill_color','ring_color'};
    for n = 1:length( rmvars )
        if isfield( residue, rmvars{n} ); residue = rmfield( residue, rmvars{n} ); end;
    end
    residue = rmgraphics( residue, {'fill_circle_handle','ring_circle_handle'} );
    setappdata( gca, res_tags{i}, residue );
end
