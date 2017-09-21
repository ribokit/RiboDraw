function setup_domain( residue_string, name );
% setup_domain( residue_string, name );
% (C) Rhiju Das, Stanford University, 2017

domain.type = 'domain'; 
domain.name = name;
domain_tag = sprintf('Selection_%s', strrep(name, ' ', '_' ) );
domain.selection_tag = domain_tag;

residue_tags = strsplit( residue_string );
resnum = []; 
chains = '';
for i = 1:length( residue_tags )
    [tag_resnum,tag_chains,ok] = get_resnum_from_tag( residue_tags{i} );
    if ok
        resnum = [ resnum, tag_resnum ];
        chains = [ chains, tag_chains ];
    else
        fprintf( 'unrecognized tag: %s. Should be of form C:50-67\n', residues_tags{i} );
    end
end

domain.associated_residues = {};
associated_helices = {};
for i = 1:length( resnum )
    res_tag = sprintf( 'Residue_%s%d', chains(i),resnum(i) );
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
    undraw_helix( helix );
    draw_helix( helix );
end

