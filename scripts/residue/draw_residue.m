function     residue = draw_residue( residue, plot_settings );
% residue = draw_residue( residue );
%
%  Render residue & any fill circles and rings.
%  Called by DRAW_HELIX
%
%  INPUT:
%    residue = residue object
%
% (C) R. Das, Stanford University 2019.
if ~exist( 'plot_settings','var' ) plot_settings = getappdata( gca, 'plot_settings' ); end;
if ~isfield( residue, 'handle' ) | ~isvalid( residue.handle )
    residue.handle = text( ...
        0, 0,...
        residue.name,...
        'fontsize', plot_settings.fontsize, ...
        'fontname','helvetica','horizontalalign','center','verticalalign','middle',...
        'clipping','off');
    if isfield( plot_settings, 'boldface' )
        if plot_settings.boldface == 1; fontweight = 'bold'; else; fontweight = 'normal'; end;
        set( residue.handle, 'fontweight',fontweight );
    end
end
if ( plot_settings.fontsize ~= get( residue.handle, 'fontsize' ) ) set( residue.handle, 'fontsize', plot_settings.fontsize ); end;
h = residue.handle;
if ( length( residue.name ) > 1 ) set( h, 'fontsize', plot_settings.fontsize*4/5); end;
if ( residue.name ~= h.String ) set( h, 'String', residue.name); end;
if isfield( residue, 'rgb_color' ) set(h,'color',residue.rgb_color ); end;
if any(isfield( residue, {'image_boundary','image_radius'} )); residue = draw_image( residue, plot_settings ); end
if any(isfield( residue, {'undercircle_face_color','undercircle_ring_color'} )); residue = draw_undercircle( residue, plot_settings ); end
