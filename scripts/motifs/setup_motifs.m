function setup_motifs( motifs )
% setup_motifs( motifs )
%
% Draw motifs as objects in the current drawing (gca).
%
% Input:
%  motifs = cell of motif objects (initialized from READ_MOTIFS )
%
% (C) R. Das, Stanford University, 2019

if ischar( motifs ) motifs = read_motifs( motifs ); end;
for i = 1:length(motifs)
    motif = motifs{i};

    % get this motif into global data (gca)
    if ~isappdata( gca, motif.motif_tag ) setappdata( gca, motif.motif_tag, motif ); end
    
    % COULD/SHOULD ADD THIS BACK IN FOR MOTIFS LIKE INTERCALATED T-LOOPS
    % and A-MINOR INTERACTIONS.
    % WHICH ARE ASSOCIATED WITH LINKERS.
    %     % add linkers
    %     possible_helix_tags = {};
    %     motif.linkers = {};
    %     for j = 1:length( motif.motif_partners )
    %         linker = struct();
    %         linker.residue1 = motif.res_tag;
    %         linker.residue2 = motif.motif_partners{j};
    %         linker.type = 'motif';
    %
    %         partner = getappdata( gca, linker.residue2 );
    %         linker_tag = sprintf('Linker_%s%s%d_%s%s%d_%s',...
    %             motif.chain,motif.segid,motif.resnum,...
    %             partner.chain,partner.segid,partner.resnum,...
    %             linker.type);
    %         linker.linker_tag = linker_tag;
    %
    %         % stick this linker information in the connected residues.
    %
    %         motif.linkers = [ motif.linkers, linker_tag ];
    %         add_linker_to_residue( linker.residue2, linker_tag );
    %         if ~isappdata( gca, linker_tag ) setappdata( gca, linker_tag, linker ); end;
    %
    %         possible_helix_tags = [ possible_helix_tags, partner.helix_tag ];
    %     end
 
    for j = 1:length( motif.associated_residues )
        residue = getappdata( gca, motif.associated_residues{j} );
        if ~isfield( residue, 'associated_motifs' ) residue.associated_motifs = {}; end;
        residue.associated_motifs = unique( [residue.associated_motifs, motif.motif_tag] );
        setappdata( gca, residue.res_tag, residue );
    end
end


