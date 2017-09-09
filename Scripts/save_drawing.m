function savedata = save_drawing( filename );
% pull information needed to render drawing from current figure ('gca'), and
% save to a JSON file.
%
% (C) R. Das, Stanford University, 2017

vals = getappdata( gca );
objnames = fields( vals );
savedata = struct();
savedata.plot_settings = getappdata( gca, 'plot_settings' );
savedata.sequence = getappdata( gca, 'sequence' );
savedata.resnum = getappdata( gca, 'resnum' );
savedata.chains = getappdata( gca, 'chains' );
savedata.non_standard_residues = getappdata( gca, 'non_standard_residues' );
if isappdata( gca, 'base_pairs' ) savedata.base_pairs = getappdata( gca, 'base_pairs' ); end;
for n = 1:length( objnames )
    if ~isempty( strfind( objnames{n}, 'Residue_' ) );
        figure_residue = getappdata( gca, objnames{n} );
        residue.resnum = figure_residue.resnum;
        residue.chain = figure_residue.chain;
        residue.helix_tag = figure_residue.helix_tag;
        residue.nucleotide = figure_residue.nucleotide;
        if isfield( figure_residue, 'stem_partner' );
            residue.stem_partner = figure_residue.stem_partner;
        end;
        
        residue.relpos = figure_residue.relpos; % needed for drawing, rel. coordinate to helix
        savedata = setfield( savedata, objnames{n}, residue );
    elseif ~isempty( strfind( objnames{n}, 'Helix_' ) );
        figure_helix = getappdata( gca, objnames{n} );
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
    end
end

savedata.xlim = get(gca, 'xlim' );
savedata.ylim = get(gca, 'ylim' );

savejson( '', savedata, filename );
