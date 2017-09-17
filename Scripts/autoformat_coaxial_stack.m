function autoformat_coaxial_stack( coaxial_stack )
% autoformat_coaxial_stack( coaxial_stack_tag )
%
% (C) Rhiju Das, Stanford University, 2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create positions of an ideal stack. This is pretty similar to what's in draw_helix.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% starter helix parent.
if length( coaxial_stack.associated_helices ) > 0;
    current_helix_tag = coaxial_stack.associated_helices{1};
else
    % its possible that this coaxial stack is all noncanonical pairs, and
    % does not include a Watson-Crick stem. In that case take the
    % parent helix of the first residues as a good parent for all the
    % rest of the residues in the coaxial stack.
    residue = getappdata( gca, coaxial_stack.associated_residues{1} );
    current_helix_tag = residue.helix_tag;
end

% residues is local working copy of the residues in the coaxial stack.
% also, figure out possible parent helix for each residue based on
% nearest helix inside this coaxial stack.
coax_pairs = coaxial_stack.coax_pairs;
N  = length( coax_pairs );
for k = 1:N
    residue1 = getappdata( gca, sprintf( 'Residue_%s%d', coax_pairs{k}.chain1,coax_pairs{k}.resnum1 ) );
    residue1.plot_pos = [ spacing*((k-1)-(N-1)/2), -bp_spacing/2];
    residues = [residues, residue1];

    residue2 = getappdata( gca, sprintf( 'Residue_%s%d', coax_pairs{k}.chain2,coax_pairs{k}.resnum2 ) );
    pos2 = [ pos2; spacing*((k-1)-(N-1)/2), +bp_spacing/2];
    residue2.plot_pos = pos2;    
    residues = [residues, residue2];
    
    if (  isfield( residue1, 'stem_partner' ) ) 
        assert( isfield( residue2, 'stem_partner' );
        assert( strcmp( residue1.stem_partner, residue2.res_tag ) );
        assert( strcmp( residue2.stem_partner, residue1.res_tag ) );
        current_helix_tag = residue1.helix_tag; 
    end
    
    set_parent_helix( residue1, current_helix_tag);
    set_parent_helix( residue2, current_helix_tag);
end

% find the largest helix associated with this domain -- superimpose based
% on those residues.
if length( coaxial_stack.associated_helices ) > 0;
    supermpose_helix = find_largest_helix( associated_helices );
    superimpose_res_idx = find_res_in_helix( residues, superimpose_helix );
else
    % if the coaxial stack does not have any stems inside it, just
    % translate/rotate to be as similar as possible to current arrangement in figure.    
    superimpose_res_idx = [1:length(residues)];
end
assert( size( superimpose_res_idx, 1 ) >= 4 );

% slight trick here -- going to use plot_pos saved in gca residues to figure out
%  how to transform positions of working residues
residues = superimpose_residues( residues, superimpose_res_idx );

% for any helices that have stem residues involved in this coaxial stack,
% recompute their helix centers, rotations, and parity to ensure that their
% residues line up OK.
% 
% Note that in some cases the associated helix is not part of coaxial
% stack (happens with base triples, I think...)
involved_helices = {};
for i = 1:length( residues )
    residue = residues{i};
    if isfield( residue, 'stem_partner' )
        involved_helices = unique( [involved_helices, residue.helix_tag ] );
        idx = find( strcmp( involved_helices, residue.helix_tag ) );
        res_idx_involved_in_helix{ idx } = [ res_idx_involved_in_helix{ idx }, i ];
    end
end
for j = 1:length( involved_helices )
    helix = getappdata( gca, involved_helices{j} );
    % brute force rotation search:
    [helix.theta, helix.parity, helix.center] = rotation_search( residue_relpos, residue_plotpos );
    setappdata( gca, 'helix' );
end

% update relpos for all residues
helices_to_redraw = {};
for i = 1:length( residues )
    helix = getappdata( gca, residue.helix_tag );
    residue.relpos = get_relpos( residue.plot_pos, helix );
    helices_to_redraw = [helices_to_redraw, helix.helix_tag ];
end

% now redraw all helices that this domain involves
helices_to_redraw = unique( helices_to_redraw );
for i = 1:length( helices_to_redraw )
    helix = getappdata( gca, helices_to_redraw );
    undraw_helix( helix );
    draw_helix( helix );
end



