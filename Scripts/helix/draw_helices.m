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

for n = 1:length( helices )
    draw_helix( helices{n} );
end

axis off
axis equal
set(gcf,'color','white')
