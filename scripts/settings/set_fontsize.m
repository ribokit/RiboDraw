function set_fontsize( fontsize )
% set_fontsize( fontsize )
%
% Set fontsize for names, and also rescale all other
%   text labels in figure based on hard-wired proportions.
% 
% (C) R. Das, Stanford University, 2017

plot_settings = getappdata( gca, 'plot_settings' );
plot_settings.fontsize = fontsize;
setappdata( gca, 'plot_settings', plot_settings );
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actually go and fix up labels
residue_tags = get_tags( 'Residue_');
for i = 1:length( residue_tags );
    residue = getappdata( gca, residue_tags{i} );
    if isfield( residue, 'handle' )
        set( residue.handle, 'fontsize', plot_settings.fontsize );
        if ( length( residue.name ) > 1 ) set( residue.handle, 'fontsize', plot_settings.fontsize*4/5); end;
        if isfield( residue, 'image_boundary' ) 
            set( residue.handle, 'fontsize', plot_settings.fontsize*1.5  ); 
             if isfield( residue, 'label' ) set( residue.label, 'fontsize', plot_settings.fontsize*14/10  ); end;
        end;
    end
    if isfield( residue, 'tick_label' )
        set( residue.tick_label, 'fontsize', plot_settings.fontsize );
    end
end
helix_tags = get_tags( 'Helix_');
for i = 1:length( helix_tags );
    helix = getappdata( gca, helix_tags{i} );
    if isfield( helix, 'label' )
        set( helix.label, 'fontsize', plot_settings.fontsize*1.5 );
    end
end
domain_tags = get_tags( 'Selection_');
for i = 1:length( domain_tags );
    domain = getappdata( gca, domain_tags{i} );
    if isfield( domain, 'label' )
        set( domain.label, 'fontsize', plot_settings.fontsize*14/10 );
    end
end


linker_tags = [get_tags( 'Linker','interdomain'); get_tags( 'Linker','intradomain')];
draw_linker( linker_tags );
