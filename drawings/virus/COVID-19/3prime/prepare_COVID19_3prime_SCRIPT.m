% prepare_COVID19_3prime_SCRIPT

sequence = 'GACCACACAAGGCAGAUGGGCUAUAUAAACGUUUUCGCUUUUCCGUUUACGAUAUAUAGUCUACUCUUGUGCAGAAUGAAUUCUCGUAACUACAUAGCACAAGUAGAUGUAGUUAACUUUAAUCUCACAUAGCAAUCUUUAAUCAGUGUGUAACAUUAGGGAGGACUUGAAAGAGCCACCACAUUUUCACCGAGGCCACGCGGAGUACGAUCGAGUGUACAGUGAACAAUGCUAGGGAGAGCUGCCUAUAUGGAAGAGCCCUAAUGUGUAAAAUUAAUUUUAGUAGUGCUAUCCCCAUGUGAUUUUAAUAGCUUCUUAGGAGAAUGACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
secstruct= '................(((((((((((..(((...((......))...))).)))))))))))..(((((((.......{{{{{{.[[[[[[[[[.)))))))...]]]]]]]]]...((((..((((((((((..((..(((.(((.....(((((((((.((.(((....)))))....(((((((((....((..((((.....))..))...))...))))).)))).((((........))))..........))))))))).....))).)))..))...)))))......)))))..))))...........}}}}}}....................................';
resnum_string = 'A:-329-31';
tag = 'COVID19_3prime';
% initialize_files( sequence, secstruct, resnum_string, tag );
% initialize_drawing(tag);
% update_helix_names( 'COVID19_3prime.stems.txt' );

setup_domain( 'A:-329--215 A:-10-31', 'PKfull' ); color_drawing( 'blue','PKfull');
setup_domain( 'A:-214--11', 'HVR' );
setup_domain( 'A:-148--104', 's2m' ); color_drawing( 'forest','s2m');
setup_domain( 'A:-95--88', 'octanucleotide' ); color_drawing( 'violet','octanucleotide');
setup_domain( 'A:-200--198', 'stop' ); color_drawing( 'red','stop');
setup_domain( 'A:-324--319', 'P0a' ); color_drawing( 'teal','P0a');

