function setup_coaxial_stacks( coaxial_stacks );

for i = 1:length( coaxial_stacks )
    coaxial_stack = coaxial_stacks{i};
    base_pair = coaxial_stack.coax_pairs{1};
    coaxial_stack_tag = sprintf( 'CoaxialStack_%s%d', ...
        base_pair.chain1, base_pair.resnum1 );
    coaxial_stack.coaxial_stack_tag = coaxial_stack_tag;
    setappdata( gca, coaxial_stack_tag, coaxial_stack );
    
    for j = 1:length( coaxial_stack.associated_helices )
        helix_tag = coaxial_stack.associated_helices{j};
        helix = getappdata( gca, helix_tag );
        if ~isfield( helix, 'associated_domains' )
            helix.associated_domains = {};
        end
        helix.associated_domains = unique( [ helix.associated_domains, coaxial_stack_tag ] );
        setappdata( gca, helix_tag, helix );
    end
    
    for j = 1:length( coaxial_stack.associated_residues )
        residue_tag = coaxial_stack.associated_residues{j};
        residue = getappdata( gca, residue_tag );
        if ~isfield( residue, 'associated_domains' )
            residue.associated_domains = {};
        end
        residue.associated_domains = unique( [ residue.associated_domains, coaxial_stack_tag ] );
        setappdata( gca, residue_tag, residue );
    end
    
end
