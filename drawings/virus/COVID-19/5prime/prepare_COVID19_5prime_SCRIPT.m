% prepare_COVID19_5prime_SCRIPT

sequence = 'AUUAAAGGUUUAUACCUUCCCAGGUAACAAACCAACCAACUUUCGAUCUCUUGUAGAUCUGUUCUCUAAACGAACUUUAAAAUCUGUGUGGCUGUCACUCGGCUGCAUGCUUAGUGCACUCACGCAGUAUAAUUAAUAACUAAUUACUGUCGUUGACAGGACACGAGUAACUCGUCUAUCUUCUGCAGGCUGCUUACGGUUUCGUCCGUGUUGCAGCCGAUCAUCAGCACAUCUAGGUUUCGUCCGGGUGUGACCGAAAGGUAAGAUGGAGAGCCUUGUCCCUGGUUUCAACGAGAAAACACACGUCCAACUCAGUUUGCCUGUUUUACAGGUUCGCGACGUGCUCGUACGUGGCUUUGGAGACUCCGUGGAGGAGGUCUUAUCAGAGGCACGUCAACAUCUUAAAGAUGGCACUUGUGGCUUAGUAGAAGUUGAAAAAGGCGUUUUGCC';
secstruct= '......(((((.(((((....)))))..)))))...........(((((.....))))).((((.......))))........((((((((.((.((((.(((.....))).)))))).))))))))(..(((((.....))))))...(((((((((((..(((((...(((.((((((((((((.((((((.(((((......)))))..))))))).....)))(((((((.((......)))))))))(((....)))))))))))))).))))).))))...))))))).......((((((.......((..((((((...))))))..))))))))(....(((((.(((((((((((((.....)))).))))..))))).)))))...(((((...)))))).......(((((.....)))))......(((.....)))';
resnum = 'A:1-450';
tag = 'COVID19_5prime';
%initialize_files( sequence, secstruct, resnum, tag );
%initialize_drawing(tag);
%update_helix_names( 'COVID19_5prime.stems.txt' );

setup_domain( 'A:107-109', 'uORF' ); color_drawing( 'pink','uORF');
setup_domain( 'A:266-268', 'ORF1a' ); color_drawing( 'red','ORF1a');

setup_domain( 'A:66-71', 'TRS' ); color_drawing( 'forest','TRS');
