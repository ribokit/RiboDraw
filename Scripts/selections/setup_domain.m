function setup_domain( residue_string, name );
% setup_domain( residue_string, name );
% (C) Rhiju Das, Stanford University, 2017

domain.type = 'domain'; 
domain.name = name;
domain_tag = sprintf('Selection_%s', strrep( strrep(name, ' ', '_' ), '-', '_' ) );
domain.selection_tag = domain_tag;

res_tags = {};
if ischar( residue_string )
    [resnum, chains, ok ] = get_resnum_from_tag( residue_string );
    if ~ok;  fprintf( 'unrecognized tag: %s. Should be of form A:1-4 C:50-67\n', residue_string ); end
    for i = 1:length( resnum )
        res_tags = [res_tags, sprintf( 'Residue_%s%d', chains(i),resnum(i) ) ];
    end
elseif iscell( residue_string )
    res_tags = residue_string;
end

domain.associated_residues = {};
associated_helices = {};
for i = 1:length( res_tags )
    res_tag = res_tags{i};
    if isappdata( gca, res_tag )
        domain.associated_residues = [domain.associated_residues, res_tag ];
        residue = getappdata( gca, res_tag );
        
        if ~isfield( residue, 'associated_selections' )
            residue.associated_selections = {};
        end
        residue.associated_selections = unique( [ residue.associated_selections, domain_tag ] );
        setappdata( gca, res_tag, residue );
        
        associated_helices = [associated_helices, residue.helix_tag ];
    else
        fprintf( 'Warning: could not find %s.\n', res_tag );
    end
end

setappdata( gca, domain_tag, domain );

associated_helices =  unique( associated_helices );
for i = 1:length( associated_helices );
    helix = getappdata( gca, associated_helices{i} );
    draw_helix( helix );
end

