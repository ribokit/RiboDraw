function update_helix_names( stems );
% update_helix_names( stems );
% 
% If we've read in helices from disk (with read_stems()) they
%  may have useful new names specified by user; update any
%  helices in appdata to have those names too.
%
% (C) R. Das, Stanford University

for n = 1:length( stems )
    stem = stems{n};
    helix_tag = sprintf('Helix_%s%d',...
        stems{n}.chain1(1),...
        stems{n}.resnum1(1));% this better be a unique identifier
    helix = getappdata( gca, helix_tag );
    helix.name = stem.name;
    if isfield( helix, 'label' )
        set( helix.label, 'String', helix.name );
    end
    setappdata( gca, helix.helix_tag, helix );
end
redraw_helices();
