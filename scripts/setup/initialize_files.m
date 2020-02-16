function initialize_files( sequence, secstruct, resnum_string, tag )
% initialize_drawing( sequence, secstruct, resnum_string, tag )
%
%
%

fastafile = [tag,'.fasta'];
fid = fopen( fastafile, 'w' );
fprintf( fid, '> %s %s\n', tag, resnum_string );
fprintf( fid, '%s\n', sequence );
fclose(fid);
fprintf( 'Made: %s\n', fastafile );
[resnum,chain,segid] = get_resnum_from_tag( resnum_string );
assert( length( resnum ) == length( sequence ) );

stems_file = [tag,'.stems.txt'];
fid = fopen( stems_file,'w' );
stem_assignment = ribodraw_figure_out_stem_assignment( secstruct );
for i = 1:max( stem_assignment )
    idx = find( stem_assignment == i );
    idx
    resnum(idx)
    chain(idx)
    segid(idx)
    ribodraw_make_tag_with_dashes(resnum(idx),chain(idx),segid(idx))
    fprintf( fid, '%s\n', ribodraw_make_tag_with_dashes(resnum(idx),chain(idx),segid(idx)) );
end
fclose(fid);
fprintf( 'Made: %s\n', stems_file );
