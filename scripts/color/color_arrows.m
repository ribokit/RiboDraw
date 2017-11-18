function color_arrows( setting );
% color_arrows( setting );
%
%  Linkers between consecutive residues with arrows are 
%   by default colored black. This function tests a setting
%   where they are colored based on the display color of the 
%   first residue.
%
% Input:
% setting = 0 or 1. (for black or colored)
%                            
% (C) R. Das, Stanford University, 2017

if ~exist( 'setting', 'var' ) setting = 1; end;
plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.color_arrows = setting;
setappdata( gca, 'plot_settings', plot_settings );

arrow_tags = get_tags( 'Linker_', 'arrow' );
color = 'k';
for i = 1:length( arrow_tags )
    linker = getappdata( gca, arrow_tags{i} );
    if isfield( linker, 'line_handle' )
        residue1 = getappdata( gca, linker.residue1 );
        if ( setting & isfield( residue1, 'rgb_color' ) ); color = residue1.rgb_color; end
        set( linker.line_handle, 'color',color);
        set( linker.arrow, 'edgecolor',color );
        set( linker.arrow, 'facecolor',color );
    end
end