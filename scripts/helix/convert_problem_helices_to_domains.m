function convert_problem_helices_to_domains()
% convert_problem_helices_to_domains()
%
% Important for multi-domain drawings with long-range pseudoknots.
%
% When a sub-drawing is imported into another one,
%  it may bring in residues that form the 'other half'
%  of a helix. 
%
% Those residues might have been positioned nicely in
%  the totally separate subdrawing which might not even know
%  about the long-range interdomain helix.
%
% This function deletes the helix and replaces it with a domain 
%  with the same helix name. The associated Watson/Crick pairs are
%  changed from the 'stem_pair' type to the 'long_range_stem_pair' type.
%
% (C) Rhiju Das, Stanford University, 2017


helix_tags = get_tags( 'Helix_' );
for i = 1:length( helix_tags )
    helix_tag = helix_tags{i};
    helix = getappdata( gca, helix_tag );
    % get res_tags that are *inside* helix (and not loop residues nearby)
    res_tags = {};
     for j = 1:length( helix.resnum1 )
        res_tags = [res_tags, sprintf( 'Residue_%s%s%d', helix.chain1(j), helix.segid1{j}, helix.resnum1(j) ) ];
    end
    for j = 1:length( helix.resnum2 )
        res_tags = [res_tags, sprintf( 'Residue_%s%s%d', helix.chain2(j), helix.segid2{j},helix.resnum2(j) ) ];
    end
    res_in_helix = 1;
    helix_tags_for_helix_res = {};
    for j = 1:length( res_tags )
        if ~isappdata( gca, res_tags{j} ) continue; end;
        residue = getappdata( gca, res_tags{j} );
        helix_tags_for_helix_res = [helix_tags_for_helix_res, residue.helix_tag ];
    end
    if any( ~strcmp( helix_tags_for_helix_res, helix_tag ) )
        helix_tags_for_helix_res = unique( helix_tags_for_helix_res );
        if length( setdiff( helix_tags_for_helix_res, helix_tag ) ) == 1 
            % maybe this is just a mistake, and there's an obvious helix to
            % which these residues can be reassigned. (happened in C1196 in my
            % ribosome layout)
            old_helix_tag = helix_tags_for_helix_res{1};
            fprintf( 'Helix_tag mismatch for %s -- some residues are misassigned to %s and will be fixed\n', helix_tag, old_helix_tag  );
            for j = 1:length( res_tags )
                residue = getappdata( gca, res_tags{j} );
                residue.helix_tag = helix_tag;
                setappdata( gca, residue.res_tag, residue );                
            end
            helix.associated_residues = res_tags;
            draw_helix( helix );
        elseif ~any( strcmp( helix_tags_for_helix_res, helix_tag ) )
            new_name = 'Domain';
            for k = 1:length( helix_tags_for_helix_res )
                other_helix = getappdata( gca, helix_tags_for_helix_res{k} );
                helix_name = other_helix.name;
                if length( helix_name ) == 0; helix_name = other_helix.tag; end;
                new_name = [new_name, '_', helix_name ];
            end
            fprintf( 'All res in helix %s are associated with other helices-- will convert this helix to a domain %s.\n', helix_tag, new_name );
            % need to go and fix up linkers.
            % a funny hack -- change linker's type from stem_pair to
            % noncanonical -- that will allow user remodeling.
            N = length( helix.resnum1 );
            for j = 1:N
                linker_tag = sprintf('Linker_%s%s%d_%s%s%d_stem_pair', helix.chain1(j), helix.segid1{j}, helix.resnum1(j),...
                    helix.chain2(N-j+1), helix.segid2{j}, helix.resnum2(N-j+1) );
                if isappdata( gca, linker_tag )
                    linker = getappdata( gca, linker_tag );
                    linker.type = 'long_range_stem_pair';
                    linker.edge1 = 'W';
                    linker.edge2 = 'W';
                    linker.LW_orientation = 'C';
                    if isfield( linker, 'line_handle' ) delete( linker.line_handle ); rmfield( linker, 'line_handle' ); end;
                    if isfield( linker, 'symbol' ) delete( linker.symbol ); rmfield( linker, 'symbol' ); end;
                    linker_tag = strrep( linker_tag, 'stem_pair','long_range_stem_pair' );
                    if ~isappdata( gca, linker_tag )
                        setappdata( gca, linker_tag, linker );
                    end
                end
            end
            setup_domain( res_tags, new_name );
            for k = 1:length( helix_tags_for_helix_res )
                draw_helix( getappdata( gca, helix_tags_for_helix_res{k} ) );
            end
            rmappdata( gca, helix_tag )
        else
            helix_tags_for_helix_res
            fprintf( 'Some problem with helix %s in which its core residues do not have the right helix_tag\n', helix_tag );
        end
    end
end
