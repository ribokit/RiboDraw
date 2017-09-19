function setup_coaxial_stacks( coaxial_stacks, delete_other_coaxial_stacks );
% setup_coaxial_stacks( coaxial_stacks, delete_other_coaxial_stacks );
% (C) Rhiju Das, Stanford University, 2017
if ~exist( 'delete_other_coaxial_stacks', 'var' ) delete_other_coaxial_stacks = 0; end;
coaxial_stack_tags = {};
for i = 1:length( coaxial_stacks )
    coaxial_stack = coaxial_stacks{i};
    base_pair = coaxial_stack.coax_pairs{1};
    coaxial_stack_tag = sprintf( 'Selection_%s%d_coaxial_stack', ...
        base_pair.chain1, base_pair.resnum1 );
    coaxial_stack.type = 'coaxial_stack';
    coaxial_stack.coaxial_stack_tag = coaxial_stack_tag;
    setappdata( gca, coaxial_stack_tag, coaxial_stack );
    
    for j = 1:length( coaxial_stack.associated_helices )
        helix_tag = coaxial_stack.associated_helices{j};
        helix = getappdata( gca, helix_tag );
        if ~isfield( helix, 'associated_selections' )
            helix.associated_selections = {};
        end
        helix.associated_selections = unique( [ helix.associated_selections, coaxial_stack_tag ] );
        setappdata( gca, helix_tag, helix );
    end
    
    for j = 1:length( coaxial_stack.associated_residues )
        residue_tag = coaxial_stack.associated_residues{j};
        residue = getappdata( gca, residue_tag );
        if ~isfield( residue, 'associated_selections' )
            residue.associated_selections = {};
        end
        residue.associated_selections = unique( [ residue.associated_selections, coaxial_stack_tag ] );
        setappdata( gca, residue_tag, residue );
    end
    
    coaxial_stack_tags= [ coaxial_stack_tags, coaxial_stack_tag ];
end


if delete_other_coaxial_stacks
    tags = get_tags( 'Selection_', 'coaxial_stack' );
    delete_tags = setdiff( tags, coaxial_stack_tags );
    for n = 1:length( delete_tags )
        delete_tag = delete_tags{n};
        coaxial_stack = getappdata( gca, delete_tag );
        
        for j = 1:length( coaxial_stack.associated_helices )
            helix_tag = coaxial_stack.associated_helices{j};
            helix = getappdata( gca, helix_tag );
            if ~isfield( helix, 'associated_selections' )
                helix.associated_selections = {};
            end
            helix.associated_selections = setdiff( helix.associated_selections, delete_tag );
            setappdata( gca, helix_tag, helix );
        end
        
        for j = 1:length( coaxial_stack.associated_residues )
            residue_tag = coaxial_stack.associated_residues{j};
            residue = getappdata( gca, residue_tag );
            if ~isfield( residue, 'associated_selections' )
                residue.associated_selections = {};
            end
            residue.associated_selections = setdiff( residue.associated_selections, delete_tag );
            setappdata( gca, residue_tag, residue );
        end
        
        if isfield( coaxial_stack,'handle' ); delete( coaxial_stack.handle ); end;
        rmappdata( gca, delete_tag );
    end
end
