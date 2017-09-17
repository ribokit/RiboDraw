function savedata = get_drawing();
% pull information needed to render drawing from current figure ('gca')
%
% (C) R. Das, Stanford University, 2017

savedata = struct();
savedata.version = '0.5';
residue_tags = get_residue_tags();
helix_tags = get_helix_tags();
linker_tags = get_linker_tags();
coaxial_stack_tags = get_coaxial_stack_tags();

% try to save in this order -- will help with rendering elements later.
savedata = save_residues( savedata, residue_tags );
savedata = save_helices(  savedata, helix_tags );
savedata = save_linkers(  savedata, linker_tags );
savedata = save_coaxial_stacks( savedata, coaxial_stack_tags );

savedata.plot_settings = getappdata( gca, 'plot_settings' );
savedata.xlim = get(gca, 'xlim' );
savedata.ylim = get(gca, 'ylim' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savedata = save_residues( savedata, objnames )

for n = 1:length( objnames )
    assert( ~isempty( strfind( objnames{n}, 'Residue_' ) ) );
    figure_residue = getappdata( gca, objnames{n} );
    clear residue;
    if ~isfield( figure_residue, 'resnum' ) continue; end; 
    residue.resnum = figure_residue.resnum;
    residue.chain = figure_residue.chain;
    residue.res_tag = figure_residue.res_tag;
    residue.helix_tag = figure_residue.helix_tag;
    residue.nucleotide = figure_residue.nucleotide;
    if isfield( figure_residue, 'stem_partner' ); residue.stem_partner = figure_residue.stem_partner; end;
    if isfield( figure_residue, 'tickrot' ); residue.tickrot = figure_residue.tickrot; end
    if isfield( figure_residue, 'rgb_color' ); residue.rgb_color = figure_residue.rgb_color; end
    residue.relpos = figure_residue.relpos; % needed for drawing, rel. coordinate to helix
    if isfield( figure_residue, 'linkers' ); residue.linkers = figure_residue.linkers; end
    if isfield( figure_residue, 'associated_domains' ) residue.associated_domains = figure_residue.associated_domains; end;

    savedata = setfield( savedata, objnames{n}, residue );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savedata = save_helices( savedata, objnames )

for n = 1:length( objnames )
    assert( ~isempty( strfind( objnames{n}, 'Helix_' ) ) );
    figure_helix = getappdata( gca, objnames{n} );
    clear helix;
    helix.resnum1 = figure_helix.resnum1;
    helix.chain1 = figure_helix.chain1;
    helix.resnum2 = figure_helix.resnum2;
    helix.chain2 = figure_helix.chain2;
    helix.name = figure_helix.name;
    
    helix.center = figure_helix.center; % needed for drawing, coordinate in global axes
    helix.rotation = figure_helix.rotation;
    helix.parity = figure_helix.parity;
    helix.label_relpos = figure_helix.label_relpos;
    
    helix.helix_tag = figure_helix.helix_tag;
    helix.associated_residues = figure_helix.associated_residues; % 'daughters'
    if isfield( figure_helix, 'associated_domains' ) helix.associated_domains = figure_helix.associated_domains; end;
    
    savedata = setfield( savedata, objnames{n}, helix );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savedata = save_coaxial_stacks( savedata, objnames )

for n = 1:length( objnames )
    assert( ~isempty( strfind( objnames{n}, 'CoaxialStack_' ) ) );
    figure_coaxial_stack = getappdata( gca, objnames{n} );
    clear coaxial_stack;
    coaxial_stack.coax_pairs = figure_coaxial_stack.coax_pairs;
    coaxial_stack.associated_residues = figure_coaxial_stack.associated_residues;
    coaxial_stack.associated_helices = figure_coaxial_stack.associated_helices;
    coaxial_stack.coaxial_stack_tag = figure_coaxial_stack.coaxial_stack_tag;
    
    savedata = setfield( savedata, objnames{n}, coaxial_stack );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savedata = save_linkers( savedata, objnames )
    
for n = 1:length( objnames )
    assert( ~isempty( strfind( objnames{n}, 'Linker_' ) ) );
    figure_linker = getappdata( gca, objnames{n} );
    clear linker;
    linker.residue1 = figure_linker.residue1;
    linker.residue2 = figure_linker.residue2;
    linker.type = figure_linker.type;
    linker.linker_tag = figure_linker.linker_tag;
    if isfield( figure_linker, 'relpos1' ); linker.relpos1 = figure_linker.relpos1;end
    if isfield( figure_linker, 'relpos2' ); linker.relpos2 = figure_linker.relpos2;end;
    if isfield( figure_linker, 'edge1' ); linker.edge1 = figure_linker.edge1; end;
    if isfield( figure_linker, 'edge2' ); linker.edge2 = figure_linker.edge2; end;
    if isfield( figure_linker, 'LW_orientation' ); linker.LW_orientation = figure_linker.LW_orientation; end;
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
function tags = get_coaxial_stack_tags();
tags = get_tags( 'CoaxialStack_' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tags = get_tags( headstring, tailstring )
vals = getappdata( gca );
objnames = fields( vals );
tags = {};
for n = 1:length( objnames )
    if isempty( strfind( objnames{n}, headstring ) ); continue; end;
    if exist( 'tailstring', 'var' ) & isempty( strfind( objnames{n}, tailstring ) ); continue; end;
    tags = [ tags, objnames{n}];
end
tags = sort( tags );
