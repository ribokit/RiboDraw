% Because there is no ground truth 3D structure, initialize from
% sequence and secondary structure instead.

sequence = 'GUUUUUAAACGGGUUUGCGGUGUAAGUGCAGCCCGUCUUACACCGUGCGGCACAGGCACUAGUACUGAUGUCGUAUACAGGGCUUUUG';
secstruct= '...............(((((((((((...[[[[[[[)))))))))))((((((((.........))).)))))...]].]]]]]....';
resnum_string = 'A:13459-13546';
tag = 'COVID19_frameshift';
initialize_files( sequence, secstruct, resnum_string, tag );
initialize_drawing( tag );

setup_domain( 'A:13461-13467', 'SlipperySite' ); color_drawing( 'red','SlipperySite');
setup_domain( 'A:13516-13521', 'DimerizationLoop' ); color_drawing( 'forest','DimerizationLoop');

