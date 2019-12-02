function     draw_residues();
% draw_residues();
%
%  Just re-render residues (after, e.g., change in fill color) --
%   note that linkers will *not* update. To do that right, use DRAW_HELIX.
%
% (C) R. Das, Stanford University 2019.
if ~exist( 'plot_settings','var' ) plot_settings = getappdata( gca, 'plot_settings' ); end;
res_tags = get_res();
for i = 1:length( res_tags )
    residue = getappdata( gca, res_tags{i} );
    residue = draw_residue( residue, plot_settings );
end
