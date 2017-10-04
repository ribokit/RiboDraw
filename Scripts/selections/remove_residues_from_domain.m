function remove_residues_from_domain( residue_string, name );
% remove_residues_from_domain( residue_string, name );
% (C) Rhiju Das, Stanford University, 2017

tag = get_domain_tag( name );

[resnum, chains, ok ] = get_resnum_from_tag( residue_string );
if ~ok;  fprintf( 'unrecognized tag: %s. Should be of form A:1-4 C:50-67\n', residue_string ); end

if isappdata( gca, tag )
    domain = getappdata(gca , tag);
    associated_residues = domain.associated_residues;
    associated_helices  = {};
    for i = 1:length( associated_residues );
        residue = getappdata( gca, associated_residues{i} );
        if ~isempty( intersect( find( resnum == residue.resnum ), strfind( chains, residue.chain ) ) )  
            fprintf( 'Removing %s from %s\n', residue.res_tag, tag );
            residue.associated_selections = setdiff( residue.associated_selections, tag );
            associated_helices = [ associated_helices, residue.helix_tag ];
            setappdata( gca, associated_residues{i}, residue );
            domain.associated_residues = setdiff( domain.associated_residues, associated_residues{i} );
        end
        setappdata( gca, tag, domain );
    end
    
    associated_helices =  unique( associated_helices );
    for i = 1:length( associated_helices );
        helix = getappdata( gca, associated_helices{i} );
        draw_helix( helix );
    end
end


