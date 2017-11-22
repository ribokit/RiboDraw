function define_helix_groups( prefix );
% define_helix_groups( prefix);
%
% Declutter drawings with lots of helices by grouping helices with similar names, and
%   showing those group names as domain labels while hiding individual helix labels.
%
% INPUT:
%  prefix = [optional] look only at helices that have form prefix + single non-numerical character. 
%              E.g., if prefix is 'H10', group together 'H10a','H10b', ...
%
% TODO: allow user specification of exactly which helices to group.
% TODO: allow auto-grouping of P10.1, P10.2, etc.
%
% (C) R. Das, Stanford University, 2017.

tags = get_tags( 'Helix' );
for i = 1:length( tags )
    helix = getappdata( gca, tags{i} );
    names{i} = helix.name;
    prefixes{i} = '';
    if isempty( str2num(helix.name(end)) )
        prefixes{i} = helix.name(1:end-1);
    end
end

if ~exist( 'prefix', 'var' )
    unique_prefixes = unique( setdiff(prefixes,'') );
else
    unique_prefixes = {prefix};
end

for j = 1:length( unique_prefixes )
    prefix = unique_prefixes{j};
    idx = find(strcmp( prefixes, prefix ));
    if length( idx ) > 1
        helixgroup_tag = sprintf( '%s_helixgroup', prefix );
        fprintf( '%s:', prefix )
        helix_res_tags = {};
        for i = idx
            helix = getappdata( gca, tags{i} );
            fprintf( ' %s', names{i} )
            N = length( helix.resnum1 );
            for k = 1:N
                % first partner of base pair -- will draw below.
                res_tag = sprintf( 'Residue_%s%s%d', helix.chain1(k), helix.segid1{k}, helix.resnum1(k) );
                helix_res_tags = [helix_res_tags, res_tag ];
                % second partner of base pair -- will draw below.
                res_tag = sprintf( 'Residue_%s%s%d', helix.chain2(N-k+1), helix.segid1{N-k+1}, helix.resnum2(N-k+1) );
                helix_res_tags = [helix_res_tags, res_tag ];
            end
        end
        fprintf( '\n' );
        
        domain_tag =  sprintf('Selection_%s_domain', strrep(helixgroup_tag, ' ', '_' ) );
        if isappdata( gca, domain_tag ) delete_domain( domain_tag ); end;
        
        domain = setup_domain( helix_res_tags, helixgroup_tag );
        domain.name = prefix;
        center_helix = getappdata( gca, tags{ idx( ceil(length(idx)/2) ) } );
        if ( isfield( center_helix,'label') )
            plot_pos = get( center_helix.label, 'position' );
            [minpos,maxpos] = get_minpos_maxpos( domain );
            ctr_pos = (minpos + maxpos )/ 2;
            domain.label_relpos = plot_pos(1:2) - ctr_pos;
            set( domain.label, 'position', plot_pos );
            set( domain.label, 'string', prefix );
        end
        domain.helix_group = 1;
        setappdata( gca, domain.selection_tag, domain );
        
        for i = idx; hide_helix_label( tags{i} ); end        
    end
end
