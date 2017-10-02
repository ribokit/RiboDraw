function savedata = get_drawing();
% pull information needed to render drawing from current figure ('gca')
%
% (C) R. Das, Stanford University, 2017

savedata = struct();
savedata.version = '0.6';
residue_tags = get_residue_tags();
helix_tags = get_helix_tags();
linker_tags = get_linker_tags();
selection_tags = get_selection_tags();

% try to save in this order -- will help with rendering elements later.
savedata = save_residues( savedata, residue_tags );
savedata = save_helices(  savedata, helix_tags );
savedata = save_linkers(  savedata, linker_tags );
savedata = save_selections( savedata, selection_tags );

savedata.plot_settings = getappdata( gca, 'plot_settings' );
savedata.xlim = get(gca, 'xlim' );
savedata.ylim = get(gca, 'ylim' );
savedata.window_position = get(gcf, 'Position' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new_obj = copy_fields( obj, tags )
new_obj = struct();
for i = 1:length( tags )
    tag = tags{i};
    if isfield( obj, tag );
        new_obj = setfield( new_obj, tag, getfield( obj, tag ) );
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savedata = save_residues( savedata, objnames )

for n = 1:length( objnames )
    assert( ~isempty( strfind( objnames{n}, 'Residue_' ) ) );
    figure_residue = getappdata( gca, objnames{n} );
    residue = copy_fields( figure_residue, {'resnum','chain','res_tag','helix_tag','nucleotide',...
        'stem_partner','tickrot','rgb_color','relpos','linkers','associated_selections'} );
    savedata = setfield( savedata, objnames{n}, residue );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savedata = save_helices( savedata, objnames )

for n = 1:length( objnames )
    assert( ~isempty( strfind( objnames{n}, 'Helix_' ) ) );
    figure_helix = getappdata( gca, objnames{n} );
    helix = copy_fields( figure_helix, {'resnum1','chain1','resnum2','chain2','name',...
        'center','rotation','parity','label_relpos','helix_tag','associated_residues','rgb_color'} );
    savedata = setfield( savedata, objnames{n}, helix );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savedata = save_selections( savedata, objnames )

for n = 1:length( objnames )
    assert( ~isempty( strfind( objnames{n}, 'Selection_' ) ) );
    figure_selection = getappdata( gca, objnames{n} );
    selection = copy_fields( figure_selection, {'associated_residues','associated_helices','selection_tag','type','coax_pairs','name',...
        'label_relpos','rgb_color','visible'} );
    savedata = setfield( savedata, objnames{n}, selection );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savedata = save_linkers( savedata, objnames )
    
for n = 1:length( objnames )
    assert( ~isempty( strfind( objnames{n}, 'Linker_' ) ) );
    figure_linker = getappdata( gca, objnames{n} );
    linker = copy_fields( figure_linker, {'residue1','residue2','type','linker_tag','relpos1',...
        'relpos2','edge1','edge2','LW_orientation'} );
    savedata = setfield( savedata, objnames{n}, linker );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tags = get_residue_tags();
tags = get_tags( 'Residue_' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tags = get_helix_tags();
tags = get_tags( 'Helix_' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tags = get_linker_tags();
stack_tags = get_tags( 'Linker_', 'stack' );
arrow_tags = get_tags( 'Linker_', 'arrow' );
stem_pair_tags = get_tags( 'Linker_', 'stem_pair' );
noncanonical_tags = get_tags( 'Linker_', 'noncanonical_pair' );
tags = [stack_tags, arrow_tags, stem_pair_tags, noncanonical_tags ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tags = get_selection_tags();
tags = get_tags( 'Selection_' );

