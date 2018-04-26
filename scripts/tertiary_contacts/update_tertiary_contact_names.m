function update_tertiary_contact_names( tags, print_stuff )
% update_tertiary_contact_names( tags, print_stuff )
% 
% Tertiary contacts have display names that can be displayed in the 'split_arrows' display mode.
%
% These names are initialized based on the names of helices that are connected by the tertiary contact,
%  or multiple helices, in the case of proteins or other ligands that interconnect numerous parts of the RNA.
%
%  There is also some fancy code to make the names render in RGB colors that reflect those helix colors for
%  tertiary contacts that involve ligands.
%
% TODO: make a function that allows user to input their own name for the tertiary contact (e.g., for alpha, beta, etc. in group II intron).
%
% Input
%  tag(s) = tags of tertiary contacts for which to define inputs. [default: all drawing tags that start with 'Tertiary']
%  print_stuff = verbose ( default 1 )
% 
% See also: GROUP_INTERDOMAIN_LINKERS, SHOW_SPLIT_ARROWS.
%
% (C) R. Das, Stanford University

if ~exist( 'print_stuff' ) print_stuff = 1; end;
if ~exist( 'tags','var' )
    tags = get_tags( 'Tertiary' );
end
if ischar( tags ); tags = {tags}; end;

for i = 1:length( tags )
    tertiary_contact = getappdata( gca, tags{i} );
    name1 = get_partner_name( tertiary_contact.associated_residues1{1}  );
    name2 = get_partner_name( tertiary_contact.associated_residues2{1}  );
    if length( name1 ) == 0; continue; end;
    if length( name2 ) == 0; continue; end;
    tertiary_contact.name = [ name1, '-', name2 ];
    
    % new special case for ligand with interdomain tertiary contacts
    residue1 = getappdata( gca, tertiary_contact.associated_residues1{1}  );
    if isfield( residue1, 'ligand_partners' )
        linker_tags = unique(get_tags( 'Linker','interdomain',residue1.linkers));
        if length( linker_tags ) > 0
            all_name = {name1};
            name = sprintf('\\color{black}%s',name1);
            for j = 1:length( linker_tags )
                if ~isappdata( gca, linker_tags{j} ); continue; end; %%% HACK HACK HACK THIS SHOULD NOT BE NECESSARY!!
                linker = getappdata( gca, linker_tags{j} );
                [name2,rgb2] = get_partner_name( linker.residue2 );
                if any( strcmp( all_name, name2 ) ) continue; end; % don't repeat
                all_name = [all_name, name2];
                if mod(length(all_name),3) == 1; name = [name,'\newline']; end;
                name = sprintf('%s-\\color[rgb]{%4.2f,%4.2f,%4.2f}%s',name,rgb2(1),rgb2(2),rgb2(3),name2);
            end
            tertiary_contact.name = name;
        end
    end
    
    if print_stuff; fprintf( 'Setting tertiary contact name %s for contact %s\n', tertiary_contact.name,tags{i} ); end;
    setappdata( gca, tags{i}, tertiary_contact );
    if isfield( tertiary_contact, 'interdomain_linker' ); draw_linker( tertiary_contact.interdomain_linker ); end;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [name,rgb] = get_partner_name( res_tag )
residue = getappdata( gca, res_tag);
name = '';
rgb = [0,0,0];
if isfield( residue, 'ligand_partners' );
    if isfield( residue, 'rgb_color' ) rgb = residue.rgb_color; end;
    name = residue.nucleotide;
    return;
elseif isfield( residue, 'helix_tag' )
    helix = getappdata( gca, residue.helix_tag );
    [name,rgb] = get_helix_name( helix, residue );
    return;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [name,rgb] = get_helix_name( helix, residue )
rgb = [0,0,0];
helix_res_tag = sprintf( 'Residue_%s%s%d', helix.chain1(1), helix.segid1{1}, helix.resnum1(1) );
helix_residue = getappdata( gca, helix_res_tag );
if isfield( helix_residue, 'rgb_color' ) rgb = helix_residue.rgb_color; end;
if isfield( helix_residue, 'associated_selections' )
    tags = get_tags( 'Selection', 'helixgroup_domain',helix_residue.associated_selections);
    if length( tags ) > 0
        helixgroup = getappdata( gca, tags{1} );
        name = helixgroup.name;
        return;
    end
end

if length( helix.name ) > 0; 
    name = helix.name;
    return;
end

% backup.
if isfield( residue, 'rgb_color' ) rgb = residue.rgb_color; end;
name = sprintf( '%s%s%d', residue.chain,residue.segid, residue.resnum );


