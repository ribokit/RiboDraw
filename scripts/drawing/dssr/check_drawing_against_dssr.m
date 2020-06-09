function [match_drawing_pairs, weak_match_drawing_pairs, non_match_drawing_pairs] = check_drawing_against_dssr( dssr_pairs );
% check_drawing_against_dssr( dssr_pairs );
%
% Will read in DSSR output file and compare base pairs
%  to stem and noncanonical pairs in drawing. 
%
% Great sanity check. Can also pipeline to script to clear out problem
% pairs.
%
% Input:
%  pdb file 
%
%    OR
%
% output file from DSSR from command line like:
%  x3dna-dssr -i=../rna_motif/1gid_RNAA.pdb -o=1gid_RNAA.pdb.dssr.out  --idstr=long 
%
%    OR
%
% .csv formatted output from web-DSSR server http://web.x3dna.org/
%
%
% Outputs
%
% match_drawing_pairs       = pairs in drawing that are found in DSSR
% weak_match_drawing_pairs  = pairs in drawing that are found in DSSR 
%                              but with different Leontis-Westhof 
%                              edge1/edge2/orientation\n
% non_match_drawing_pairs   = pairs in drawing that are *not* found in DSSR
% 
% (C) R. Das, Stanford University 2020.

linker_pairs = get_tags( 'Linker','pair' );
drawing_pairs = {};
for i = 1:length( linker_pairs )
    linker = getappdata( gca, linker_pairs{i} );
    drawing_pair = struct();
    if strcmp(linker.type,'stem_pair');
        drawing_pair.edge1 = 'W'; drawing_pair.edge2 = 'W'; drawing_pair.LW_orientation = 'C';
    else
        drawing_pair.edge1 = linker.edge1; drawing_pair.edge2 = linker.edge2; drawing_pair.LW_orientation = linker.LW_orientation;
    end
    res1 = getappdata( gca, linker.residue1 );
    drawing_pair.resnum1  = res1.resnum;
    drawing_pair.chain1 = res1.chain;
    drawing_pair.name1 = res1.name;
    res2 = getappdata( gca, linker.residue2 );
    drawing_pair.resnum2 = res2.resnum;
    drawing_pair.chain2 = res2.chain;
    drawing_pair.name2 = res2.name;
    drawing_pair.tag = linker_pairs{i};
    drawing_pairs = [drawing_pairs, drawing_pair];
end

% First go through drawing and check against dssr

[match_drawing_pairs,weak_match_drawing_pairs,non_match_drawing_pairs] = look_for_pairs( drawing_pairs, dssr_pairs, 'drawing','DSSR');
[match_dssr_pairs,weak_match_dssr_pairs,non_match_dssr_pairs] = look_for_pairs( dssr_pairs, drawing_pairs, 'DSSR','drawing');
assert( length( match_drawing_pairs ) == length( match_dssr_pairs ) );
assert( length( weak_match_drawing_pairs ) == length( weak_match_dssr_pairs ) );

fprintf( '\n\nFollowing drawing pairs are found by DSSR\n' )
output_pairs( match_drawing_pairs );

fprintf( '\n\nFollowing drawing pairs are found by DSSR but with different Leontis-Westhof edge1/edge2/orientation\n' )
output_pairs( weak_match_drawing_pairs );

fprintf( '\n\nFollowing drawing pairs are *not* found by DSSR\n' )
output_pairs( non_match_drawing_pairs );

fprintf( '\n\nFollowing DSSR pairs are *not* found in drawing\n' )
output_pairs( non_match_dssr_pairs );

fprintf('\n\n');
fprintf( 'Number of matched pairs: %d\n',length(match_drawing_pairs))
fprintf( 'Number of weak matched pairs: %d\n',length(weak_match_drawing_pairs))
fprintf( 'Number of drawing pairs that do not match DSSR: %d\n',length(non_match_drawing_pairs))
fprintf( 'Number of DSSR pairs that do not match drawing: %d\n',length(non_match_dssr_pairs))


%%%%%%%%%%%%%%
function [match_pairs, weak_match_pairs, non_match_pairs] = look_for_pairs( drawing_pairs, dssr_pairs, drawing_tag, dssr_tag);
match_pairs = {};
weak_match_pairs = {};
non_match_pairs = {};
for i = 1:length( drawing_pairs )
    drawing_pair = drawing_pairs{i};
    found_match = 0;
    for j = 1:length( dssr_pairs )
        dssr_pair = dssr_pairs{j};
        if ( ...
                dssr_pair.resnum1 == drawing_pair.resnum1 && strcmp( dssr_pair.chain1, drawing_pair.chain1 ) && ...
                dssr_pair.resnum2 == drawing_pair.resnum2 && strcmp( dssr_pair.chain2, drawing_pair.chain2 ) && ...
                strcmp(dssr_pair.edge1,drawing_pair.edge1) && strcmp(dssr_pair.edge2,drawing_pair.edge2)  && ...
                strcmp( dssr_pair.LW_orientation, drawing_pair.LW_orientation ) )
            found_match = 1;
        end
    end
    if ~found_match
        found_weak_match = 0;
        for j = 1:length( dssr_pairs )
            dssr_pair = dssr_pairs{j};
            if ( ...
                    dssr_pair.resnum1 == drawing_pair.resnum1 && strcmp( dssr_pair.chain1, drawing_pair.chain1 ) && ...
                    dssr_pair.resnum2 == drawing_pair.resnum2 && strcmp( dssr_pair.chain2, drawing_pair.chain2 ) )
                found_weak_match = 1;
            end
        end
        if found_weak_match
            weak_match_pairs = [weak_match_pairs, drawing_pair];
        else
            non_match_pairs = [non_match_pairs, drawing_pair];
        end
    else
        match_pairs = [match_pairs, drawing_pair];
    end
end

%%%%%%%%%%%%%%%
function output_pairs( drawing_pairs );
for i = 1:length( drawing_pairs )
    drawing_pair = drawing_pairs{i};
    fprintf( '%s:%s%d %s:%s%d %s%s%s', ...
        drawing_pair.chain1,drawing_pair.name1,drawing_pair.resnum1,...
        drawing_pair.chain2,drawing_pair.name2,drawing_pair.resnum2,...
        lower(drawing_pair.LW_orientation),drawing_pair.edge1,drawing_pair.edge2);
    if isfield( drawing_pair, 'tag' );
        fprintf( '     %s', drawing_pair.tag );
    end
    fprintf( '\n' );        
end

