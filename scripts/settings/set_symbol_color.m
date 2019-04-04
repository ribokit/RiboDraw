function set_symbol_color( color );
%
% update colors of all arrows and Leontis-Westhof symbols
%
% (C) R. Das, Stanford University, 2019

plot_settings = get_plot_settings();
plot_settings.symbol_color = color;
setappdata( gca, 'plot_settings', plot_settings );

bg_color = get(gcf, 'Color' ); % background_color

linker_tags = get_tags( 'Linker_' );
symbol_handles = {'symbol','symbol1','symbol2'};
for i = 1:length( linker_tags );
    linker = getappdata( gca, linker_tags{i} );
    if isfield( linker, 'arrow' );
        set( linker.arrow, 'facecolor', color );
        set( linker.arrow, 'edgecolor', color );
    elseif any( isfield( linker, {'symbol','symbol1','symbol2'} ) )
        % Worked out logic to 'invert' symbols so that their fill matches
        % background, but it looks pretty weird, so skipping with a
        % "continue"
        continue;  % skip
        for j = 1:length( symbol_handles );
            symbol_handle = symbol_handles{j};
            if isfield( linker, symbol_handle )
                h = getfield( linker, symbol_handle );
                set( h, 'edgecolor', color );
                if isfield( linker, 'LW_orientation') && strcmp( linker.LW_orientation, 'T' )
                    set( h, 'facecolor', bg_color );
                else
                    set( h, 'facecolor', color );
                end
            end
        end
    end
end

