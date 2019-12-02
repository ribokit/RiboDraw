function set_line_color( color );
%
% update colors of all lines in linkers, ticks, and tick labels
%
% (C) R. Das, Stanford University, 2019

plot_settings = get_plot_settings();
plot_settings.line_color = color;
setappdata( gca, 'plot_settings', plot_settings );

linker_tags = get_tags( 'Linker_' );
for i = 1:length( linker_tags );
    linker = getappdata( gca, linker_tags{i} );
    if ~isfield( linker, 'line_handle' ); continue; end;
    set( linker.line_handle, 'color', color );
end

res_tags = get_res_tags();
for i = 1:length( res_tags );
    residue = getappdata( gca, res_tags{i} );
    if isfield( residue, 'tick_handle' )
        set( residue.tick_handle, 'color', color );
    end
    if isfield( residue, 'tick_label' )
        set( residue.tick_label, 'color', color );
    end
end
    
