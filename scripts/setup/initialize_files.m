function initialize_files( sequence, secstruct, resnum, tag )
% initialize_drawing( sequence, secstruct, tag )


fastafile = [tag,'.fasta'];
fid = fopen( fastafile, 'w' );
fprintf( fid, '> %s %s\n', tag, resnum );
fprintf( fid, '%s\n', sequence );
fclose(fid);
fprintf( 'Made: %s\n', fastafile );

stems_file = [tag,'.stems.txt'];
fid = fopen( stems_file,'w' );
stem_assignment = ribodraw_figure_out_stem_assignment( secstruct );
for i = 1:max( stem_assignment )
    idx = find( stem_assignment == i );
    fprintf( fid, '%s\n', ribodraw_make_tag_with_dashes(idx) );
end
fclose(fid);
fprintf( 'Made: %s\n', stems_file );
