function savedata = save_drawing( filename );
% pull information needed to render drawing from current figure ('gca'), and
% save to a JSON file.
%
% (C) R. Das, Stanford University, 2017

vals = getappdata( gca );
objnames = fields( vals );
savedata = struct();
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Residue_' ) );
        figure_residue = getappdata( gca, objnames{n} );
        clear residue;
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
        savedata = setfield( savedata, objnames{n}, residue );
    elseif ~isempty( strfind( objnames{n}, 'Helix_' ) );
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
        
        savedata = setfield( savedata, objnames{n}, helix );
    elseif ~isempty( strfind( objnames{n}, 'Linker_' ) );
        figure_linker = getappdata( gca, objnames{n} );
        clear linker;
        linker.residue1 = figure_linker.residue1;
        linker.residue2 = figure_linker.residue2;
        linker.type = figure_linker.type;
        linker.linker_tag = figure_linker.linker_tag;
        if isfield( figure_linker, 'edge1' ); linker.edge1 = figure_linker.edge1; end;
        if isfield( figure_linker, 'edge2' ); linker.edge2 = figure_linker.edge2; end;
        if isfield( figure_linker, 'LW_orientation' ); linker.LW_orientation = figure_linker.LW_orientation; end;
        savedata = setfield( savedata, objnames{n}, linker );
    end
end

savedata.plot_settings = getappdata( gca, 'plot_settings' );
savedata.xlim = get(gca, 'xlim' );
savedata.ylim = get(gca, 'ylim' );

savejson( '', savedata, filename );
