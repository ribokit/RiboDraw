function draw_helices( helices )
% draw_helices( helices )
%
% Render initial helices for RiboDraw drawing, as well
%   as associated residues, linkers, and base pairs.
%
% Wrapper around draw_helix().
%
% If helices not supplied, find all objects in current
%  figure axes with names like "Helix_C1247" 
%
% (C) R. Das, Stanford University, 2017

if ~exist( 'helices', 'var' )
    helices = {};
    appdata = getappdata( gca );
    objnames = fields( appdata );
    for n = 1:length( objnames )
        if ~isempty( strfind( objnames{n}, 'Helix_' ) );
            helices = [helices,getfield(appdata,objnames{n})];
        end
    end
end

% for speed, don't show domains until end.
save_show_domains = temporarily_hide_domains();

textprogressbar('Drawing helices... ');
for n = 1:length( helices )
    draw_helix( helices{n} );
    textprogressbar( 100 * n/length(helices) );
end
textprogressbar(' done');
axis off

%axis equal
bg_color = 'white';
plot_settings = get_plot_settings();
if isfield( plot_settings, 'bg_color' ); bg_color = plot_settings.bg_color; end;
set(gcf,'color',bg_color)
if save_show_domains; show_domains(1,0); end;
if isfield( plot_settings, 'show_base_rope' ) && plot_settings.show_base_rope; draw_base_rope(); end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_show_domains = temporarily_hide_domains();
plot_settings = getappdata( gca, 'plot_settings' );
save_show_domains = plot_settings.show_domains; 
if save_show_domains; 
    plot_settings.show_domains = 0;
    setappdata( gca, 'plot_settings', plot_settings );
end;
