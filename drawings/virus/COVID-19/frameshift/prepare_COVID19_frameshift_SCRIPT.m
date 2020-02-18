% prepare_COVID19_3prime_SCRIPT

sequence = 'GUUUUUAAACGGGUUUGCGGUGUAAGUGCAGCCCGUCUUACACCGUGCGGCACAGGCACUAGUACUGAUGUCGUAUACAGGGCUUUUG';
secstruct= '................(((((((((((..[[[[[))))))))))(((((((((((.........))).))))))))...]]]]]....';
resnum_string = 'A:13459-13546';
tag = 'COVID19_frameshift';
% initialize_files( sequence, secstruct, resnum_string, tag );
% initialize_drawing(tag);
% update_helix_names( 'COVID19_3prime.stems.txt' );

%%
setup_domain( 'A:13461-13467', 'SlipperySite' ); color_drawing( 'red','SlipperySite');
setup_domain( 'A:13516-13521', 'DimerizationLoop' ); color_drawing( 'forest','DimerizationLoop');

